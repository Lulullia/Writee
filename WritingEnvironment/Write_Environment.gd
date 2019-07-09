extends Control

func _ready():
	$FileMenu.get_popup().connect("id_pressed", self, "_on_FileMenu_pressed")

func _on_FileMenu_pressed(id):
	match id:
		#Open
		0:
			$FileMenu/OpenFile.popup()
		#Save As
		1:
			$FileMenu/SaveAsFile.popup()
		#Quit
		2:
			GLOBAL._quit()


#func _on_Open_pressed():
#	$Open/FileDialog.popup()
#
#
#func _on_Save_pressed():
#	$SaveAs/FileDialog.popup()


func _on_OpenFile_file_selected(path):
	print(path)
	var file = File.new()
	file.open(path, 1)
	$TextEdit.text = file.get_as_text()
	file.close()


func _on_SaveAsFile_file_selected(path):
	var file = File.new()
	file.open(path, 2)
	file.store_string($TextEdit.text)
	file.close()
