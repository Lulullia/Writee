extends Control

signal open_file
signal close_file

onready var file_menu = get_node("Menus/File")

func _ready():
	file_menu.get_popup().connect("id_pressed", self, "_on_FileMenu_pressed")


func _on_FileMenu_pressed(id):
	match id:
		#New
		0:
			GLOBAL.set_current_filename("Untitled")
			emit_signal("open_file", "", true)
		#Open
		1:
			$Menus/File/Open.popup()
		#Save
		2:
			if GLOBAL.current_filepath:
				GLOBAL._save(false)
			else:
				$Menus/File/SaveAs.popup()
		#Save As
		3:
			$Menus/File/SaveAs.popup()
		#Close
		4:
			emit_signal("close_file")


func _on_Open_file_selected(path):
	var file = File.new()
	file.open(path, 1)
	var text = file.get_as_text()
	file.close()
	
	GLOBAL.set_current_filename($Menus/File/Open.get_current_file())
	GLOBAL.set_current_filepath(path)
	
	emit_signal("open_file", text, true)



func _on_SaveAs_file_selected(path):
	GLOBAL._save(false)
	
	GLOBAL.set_current_filename($Menus/File/SaveAs.get_current_file())
	GLOBAL.set_current_filepath(path)
	
	emit_signal("open_file", "", false)
