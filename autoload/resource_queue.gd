extends Node

var thread: Thread
var mutex: Mutex
var semaphore: Semaphore
var exit_thread := false
var start_called := false

var queue := []
var pending := {}

func start() -> void:
  start_called = true
  mutex = Mutex.new()
  semaphore = Semaphore.new()
  thread = Thread.new()
  thread.start(Callable(self,"thread_func"))

func thread_func() -> void:
  while true:
    if exit_thread:
      break
    thread_process()

func thread_process() -> void:
  semaphore.wait()
  mutex.lock()

  while queue.size() > 0:
    var resource = queue[0]
    mutex.unlock()
    var ret = resource.poll()
    mutex.lock()

    if ret == ERR_FILE_EOF || ret != OK:
      var path = resource.get_meta("path")
      if path in pending: # Else, it was already retrieved.
        pending[resource.get_meta("path")] = resource.get_resource()
      # Something might have been put at the front of the queue while
      # we polled, so use erase instead of remove_at.
      queue.erase(resource)
  mutex.unlock()

func queue_resource(path, place_in_front = false) -> void:
  mutex.lock()
  if path in pending: # If already queued.
    mutex.unlock()
    return
  elif ResourceLoader.has_cached(path):
    var resource = ResourceLoader.load(path)
    pending[path] = resource
    mutex.unlock()
    return
  else:
    # TODO: This blocks the thread until loading is done.
    # Should be refactored to allow for background loading.
    ResourceLoader.load_threaded_request(path, "", true)
    var resource = ResourceLoader.load_threaded_get(path)
    resource.set_meta("path", path)
    if place_in_front:
      queue.insert(0, resource)
    else:
      queue.push_back(resource)
    pending[path] = resource
    semaphore.post()
    mutex.unlock()
    return

func cancel_resource(path) -> void:
  mutex.lock()
  if path in pending:
    if not pending[path] is PackedScene:
      queue.erase(pending[path])
    pending.erase(path)
  mutex.unlock()

func get_progress(path) -> float:
  mutex.lock()
  var ret = -1
  if path in pending:
    if not pending[path] is PackedScene:
      ret = float(pending[path].get_stage()) / float(pending[path].get_stage_count())
    else:
      ret = 1.0
  mutex.unlock()
  return ret

func is_ready(path) -> bool:
  var ret
  mutex.lock()
  if path in pending:
    ret = pending[path] is PackedScene
  else:
    ret = false
  mutex.unlock()
  return ret

func _wait_for_resource(res, path):
  mutex.unlock()
  while true:
    RenderingServer.force_sync()
    OS.delay_usec(16000) # Wait approximately 1 frame.
    mutex.lock()
    if queue.size() == 0 || queue[0] != res:
      return pending[path]
    mutex.unlock()

func get_resource(path) -> Resource:
  mutex.lock()
  if path in pending:
    if not pending[path] is PackedScene:
      var resource = pending[path]
      if resource != queue[0]:
        var pos = queue.find(resource)
        queue.remove_at(pos)
        queue.insert(0, resource)

      resource = _wait_for_resource(resource, path)
      pending.erase(path)
      mutex.unlock()
      return resource
    else:
      var resource = pending[path]
      pending.erase(path)
      mutex.unlock()
      return resource
  else:
    mutex.unlock()
    return ResourceLoader.load(path)

# Triggered by calling "get_tree().quit()".
func _exit_tree() -> void:
  if start_called: # If a scene was started from the editor, "start" won't have been called.
    mutex.lock()
    exit_thread = true # Will stop "thread_func".
    mutex.unlock()
    
    semaphore.post() # Unblock by posting.
    thread.wait_to_finish() # Wait until it exits.
