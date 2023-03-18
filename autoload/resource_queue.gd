extends Node

var thread: Thread
var mutex: Mutex
var semaphore: Semaphore
var exit_thread := false
var start_called := false

var time_max := 100 # Milliseconds.

var queue := []
var pending := {}

func _lock(_caller) -> void:
  mutex.lock()

func _unlock(_caller) -> void:
  mutex.unlock()

func _post(_caller) -> void:
  semaphore.post()

func _wait(_caller) -> void:
  semaphore.wait()

func queue_resource(path, p_in_front = false) -> void:
  _lock("queue_resource")
  if path in pending:
    _unlock("queue_resource")
    return
  elif ResourceLoader.has_cached(path):
    var res = ResourceLoader.load(path)
    pending[path] = res
    _unlock("queue_resource")
    return
  else:
    # TODO: This blocks the thread until loading is done.
    # Should be refactored to allow for background loading.
    ResourceLoader.load_threaded_request(path, "", true)
    var res = ResourceLoader.load_threaded_get(path)
    res.set_meta("path", path)
    if p_in_front:
      queue.insert(0, res)
    else:
      queue.push_back(res)
    pending[path] = res
    _post("queue_resource")
    _unlock("queue_resource")
    return

func cancel_resource(path) -> void:
  _lock("cancel_resource")
  if path in pending:
    if not pending[path] is PackedScene:
      queue.erase(pending[path])
    pending.erase(path)
  _unlock("cancel_resource")

func get_progress(path) -> float:
  _lock("get_progress")
  var ret = -1
  if path in pending:
    if not pending[path] is PackedScene:
      ret = float(pending[path].get_stage()) / float(pending[path].get_stage_count())
    else:
      ret = 1.0
  _unlock("get_progress")
  return ret

func is_ready(path) -> bool:
  var ret
  _lock("is_ready")
  if path in pending:
    ret = pending[path] is PackedScene
  else:
    ret = false
  _unlock("is_ready")
  return ret

func _wait_for_resource(res, path):
  _unlock("wait_for_resource")
  while true:
    RenderingServer.force_sync()
    OS.delay_usec(16000) # Wait approximately 1 frame.
    _lock("wait_for_resource")
    if queue.size() == 0 || queue[0] != res:
      return pending[path]
    _unlock("wait_for_resource")

func get_resource(path) -> Resource:
  _lock("get_resource")
  if path in pending:
    if not pending[path] is PackedScene:
      var res = pending[path]
      if res != queue[0]:
        var pos = queue.find(res)
        queue.remove_at(pos)
        queue.insert(0, res)

      res = _wait_for_resource(res, path)
      pending.erase(path)
      _unlock("return")
      return res
    else:
      var res = pending[path]
      pending.erase(path)
      _unlock("return")
      return res
  else:
    _unlock("return")
    return ResourceLoader.load(path)

func thread_process() -> void:
  _wait("thread_process")
  _lock("process")

  while queue.size() > 0:
    var res = queue[0]
    _unlock("process_poll")
    var ret = res.poll()
    _lock("process_check_queue")

    if ret == ERR_FILE_EOF || ret != OK:
      var path = res.get_meta("path")
      if path in pending: # Else, it was already retrieved.
        pending[res.get_meta("path")] = res.get_resource()
      # Something might have been put at the front of the queue while
      # we polled, so use erase instead of remove_at.
      queue.erase(res)
  _unlock("process")

func thread_func(_u) -> void:
  while true:
    mutex.lock()
    var should_exit = exit_thread # Protect with Mutex.
    mutex.unlock()

    if should_exit:
      break
    thread_process()

func start() -> void:
  exit_thread = false
  start_called = true
  mutex = Mutex.new()
  semaphore = Semaphore.new()
  thread = Thread.new()
  thread.start(Callable(self,"thread_func").bind(0))

# Triggered by calling "get_tree().quit()".
func _exit_tree() -> void:
  if start_called: # If a scene was started from the editor, "start" won't have been called.
    # Set exit condition to true.
    mutex.lock()
    exit_thread = true # Protect with Mutex.
    mutex.unlock()
    
    # Unblock by posting.
    semaphore.post()
    
    # Wait until it exits.
    thread.wait_to_finish()
