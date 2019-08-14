extends Node

###SIGNALS###
signal saved

###############
###VARIABLES###
###############

const UNTITLED = "Untitled"

onready var Manus_text_env = get_node("/root/Main/Text/Write_Environment/TextEdit")

var app_name = "Writee"

var current_filename = UNTITLED
var current_filepath

var previous_filename = []
var previous_filepath = []

#Init
func _ready():
	
	
	Input.set_custom_mouse_cursor(load("res://Assets/png/cursor_pointer3D.png"), Input.CURSOR_POINTING_HAND)
	
	var system = File.new()
	system.open("user/system.wrt", 1)
#	previous_filename = parse_json(system.get_line())
#	previous_filepath = parse_json(system.get_line())
	system.close()
	print(previous_filename)
	print(previous_filepath)


#Saving
func _save():
	print("saving")
	emit_signal("saved")


#Quitting
func _quit():
	
	#Add a "do you want to save" reminder
	
	if current_filepath:
		previous_filename.push_front(current_filename)
		previous_filepath.push_front(current_filepath)
	
		var system = File.new()
		system.open("user/system.wrt", 2)
		system.store_line(to_json(previous_filename))
		system.store_line(to_json(previous_filepath))
		system.close()
	
	get_tree().quit()