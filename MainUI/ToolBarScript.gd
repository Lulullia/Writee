extends HBoxContainer

###VARIABLES###

var following = false
var drag_start_pos = Vector2()


###FUNCTIONS###
#func _ready():
#	_update_window_title()

func _process(delta):
	
	if following:
		OS.set_window_position(OS.window_position + 
							get_global_mouse_position() - drag_start_pos)

func _update_window_title():
	$DocTitle.text = GLOBAL.current_filename


###SIGNAL FUNCTIONS###
#Window dragging
func _on_ToolBar_gui_input(event):
	if event is InputEventMouseButton && event.get_button_index() == 1:
		following = !following
		drag_start_pos = get_local_mouse_position()

#Minimize
func _on_Minimize_pressed():
	OS.set_window_minimized(true)

#Fullscreen
func _on_Fullscreen_toggled(button_pressed):
	if button_pressed:
		OS.window_fullscreen = true
		$Fullscreen.icon = load("res://Assets/png/smaller.png")
	if !button_pressed:
		$Fullscreen.icon = load("res://Assets/png/larger.png")
		OS.window_fullscreen = false

#Close
func _on_Close_pressed():
	if !GLOBAL.current_filepath:
		$Close/SaveConfirm.popup()
	else:
		$Close/QuitConfirm.popup()

func _on_QuitYes_pressed():
	GLOBAL._quit()
func _on_QuitNo_pressed():
	$Close/QuitConfirm.hide()

func _on_SaveNo_pressed():
	GLOBAL._quit()
func _on_SaveYes_pressed():
	GLOBAL._save()
	yield(GLOBAL, "saved")
	$Close/SaveConfirm.hide()
	GLOBAL._quit()
func _on_SaveCancel_pressed():
	$Close/SaveConfirm.hide()


