extends Control



func _on_Button_pressed():
	$TextEdit2.cursor_set_line(13, true, true)
	$TextEdit2.set_line_as_hidden(13, true)


func _on_Button2_pressed():
	$TextEdit2.set_line_as_hidden(13, false)
