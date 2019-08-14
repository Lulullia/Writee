extends Control

onready var file_menu = get_node("Menus/File")

func _ready():
	file_menu.get_popup().connect("id_pressed", self, "_on_FileMenu_pressed")
	_apply_shortcuts()


func _apply_shortcuts():
	for action in [0, 1, 2, 3, 4]:
		var scancode
		var shortcut = ShortCut.new()
		var inputevent = InputEventKey.new()
		match action:
			0:
				scancode = 78
				inputevent.control = true
			1:
				pass
			2:
				scancode = 83
				inputevent.control = true
			3:
				pass
			4:
				scancode = 81
				inputevent.control = true
		if scancode:
			inputevent.set_scancode(scancode)
			shortcut.set_shortcut(inputevent)
			file_menu.get_popup().set_item_shortcut(action, shortcut, true)


func _on_FileMenu_pressed(id):
	match id:
		#New
		0:
			GLOBAL.current_filename = "Untitled"
			GLOBAL._update_window_title()
			GLOBAL.Manus_text_env.text = ""
		#Open
		1:
			$Menus/File/Open.popup()
		#Save
		2:
			if GLOBAL.current_filepath:
				var file = File.new()
				file.open(GLOBAL.current_filepath, 2)
				file.store_string(GLOBAL.Manus_text_env.text)
				file.close()
			else:
				$Menus/File/SaveAs.popup()
		#Save As
		3:
			$Menus/File/SaveAs.popup()
		#Quit
		4:
			GLOBAL._quit()


func _on_Open_file_selected(path):
	print(path)
	var file = File.new()
	file.open(path, 1)
	GLOBAL.Manus_text_env.text = file.get_as_text()
	file.close()
	
	GLOBAL.current_filename = path
	GLOBAL.current_filepath = path
	GLOBAL._update_window_title()


func _on_SaveAs_file_selected(path):
	var file = File.new()
	file.open(path, 2)
	file.store_string(GLOBAL.Manus_text_env.text)
	file.close()
	
	GLOBAL.current_filename = path
	GLOBAL.current_filepath = path
	GLOBAL._update_window_title()
