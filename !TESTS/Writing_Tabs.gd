extends Tabs

signal wanna_save

var scene_text

func get_scene_text():
	scene_text = $Write_Environment.get_actual_text()
	return scene_text

func _on_Write_Environment_wanna_save():
	emit_signal("wanna_save", self)
