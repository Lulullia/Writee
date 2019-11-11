extends HBoxContainer

###VARIABLES###

var following = false
var drag_start_pos = Vector2()

###FUNCTIONS###

# warning-ignore:unused_argument
func _process(delta):
	
	if following:
		OS.set_window_position(OS.window_position + 
							get_global_mouse_position() - drag_start_pos)

###SIGNAL FUNCTIONS###
#Window dragging
func _on_Toolbar_gui_input(event):
	if event is InputEventMouseButton && event.get_button_index() == 1:
		following = !following
		drag_start_pos = get_local_mouse_position()

#Minimize
func _on_Minimize_pressed():
	OS.set_window_minimized(true)

#Close
func _on_Close_pressed():
	GLOBAL._quit()

