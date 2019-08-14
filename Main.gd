extends Node


func _on_MainUI_open_file(text, override):
	$ToolBar._update_window_title()
	if override:
		$Text/Write_Environment.set_actual_text(text)
	else:
		pass
