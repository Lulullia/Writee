extends Node


###############
###VARIABLES###
###############

var app_name = "Writee"

var current_filename = "Untitled" setget set_current_filename, get_current_filename
var current_filepath setget set_current_filename, get_current_filepath

var previous_filename = []
var previous_filepath = []

#Init
func _ready():
	
	var system = File.new()
	system.open("user/system.wrt", 1)
#	previous_filename = parse_json(system.get_line())
#	previous_filepath = parse_json(system.get_line())
	system.close()
	print(previous_filename)
	print(previous_filepath)

#Input
func _input(event):
	
	if event is InputEventKey:
		if event.pressed && event.scancode == 83 && Input.is_action_pressed("save"):
			_save(false)

#Saving
func _save(quitting):
	#Save code
	print("saving")
	#When save is complete
	if quitting:
		_quit()
	else:
		pass


#Quitting
func _quit():
	
	if current_filepath:
		previous_filename.push_front(current_filename)
		previous_filepath.push_front(current_filepath)
	
		var system = File.new()
		system.open("user/system.wrt", 2)
		system.store_line(to_json(previous_filename))
		system.store_line(to_json(previous_filepath))
		system.close()
	
	get_tree().quit()

###SETTERS & GETTERS###

func set_current_filename(value):
	current_filename = value
func get_current_filename():
	return current_filename

func set_current_filepath(value):
	current_filepath = value
func get_current_filepath():
	return current_filepath

