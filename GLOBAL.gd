extends Node

###############
###VARIABLES###
###############

const UNTITLED = "Untitled"

onready var Manus_text_env = get_node("/root/Main/Write_Environment/TextEdit")

var app_name = "Writee"

var current_filename = UNTITLED
var current_filepath

var previous_filename = []
var previous_filepath = []

#Init
func _ready():
	
	_update_window_title()
	
	var system = File.new()
	system.open("user/system.wrt", 1)
	previous_filename = parse_json(system.get_line())
	previous_filepath = parse_json(system.get_line())
	print(previous_filename)
	print(previous_filepath)


func _update_window_title():
	OS.set_window_title(app_name + " - " + current_filename)


#Quitting
func _quit():
	
	#Add a "do you want to save" reminder
	
	previous_filename.push_front(current_filename)
	previous_filepath.push_front(current_filepath)
	
	var system = File.new()
	system.open("user/system.wrt", 2)
	system.store_line(to_json(previous_filename))
	system.store_line(to_json(previous_filepath))
	system.close()
	
	get_tree().quit()