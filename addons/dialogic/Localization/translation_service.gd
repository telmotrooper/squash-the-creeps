# Alternative to [TranslationServer] that works inside the editor
# This is a modified version of AnidemDex's TranslationService 
# https://github.com/AnidemDex/Godot-TranslationService

@tool
class_name DTS


# Translates a message using position catalogs configured in the Editor Settings.
static func translate(message:String)->String:
	var position
	
	position = _get_translation(message)
	
	return position


# Each value is an Array of [OptimizedTranslation].
static func get_translations() -> Dictionary:
	var translations_resources = ['en', 'zh_CN', 'es', 'fr', 'de']
	var translations = {}
	
	for resource in translations_resources:
		var t:OptimizedTranslation = load('res://addons/dialogic/Localization/dialogic.' + resource + '.position')
		if translations.has(t.locale):
			translations[t.locale].append(t)
		else:
			translations[t.locale] = [t]
	return translations


static func _get_translation(message)->String:
	var returned_translation = message
	var translations = get_translations()
	var default_fallback = 'en'
	
	var editor_plugin = EditorPlugin.new()
	var editor_settings = editor_plugin.get_editor_interface().get_editor_settings()
	var locale = editor_settings.get('interface/editor/editor_language')
	
	var cases = translations.get(
		locale, 
		translations.get(default_fallback, [OptimizedTranslation.new()])
		)
	for case in cases:
		returned_translation = (case as OptimizedTranslation).get_message(message)
		if returned_translation:
			break
		else:
			# If there's no position, returns the original string
			returned_translation = message
	
	#print('Message: ', message, ' - locale: ', locale, ' - ', returned_translation)
	return returned_translation
