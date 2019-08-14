extends Control

var actual_text

func _ready():
	$FileDialog.set_filters(PoolStringArray(["*.png ; PGN Images","*.jpg ; JPG Images","*.jpeg ; JPEG Images"]))

func _on_RichTextLabel_gui_input(event):
	if event is InputEventMouseButton && event.get_button_index() == 1:
		$RichTextLabel.visible = false
		actual_text = $RichTextLabel.bbcode_text
		$TextEdit.text = actual_text
		$TextEdit.readonly = false
		$TextEdit.visible = true
		$save.disabled = false
		$image.disabled = false
		$bold.disabled = false
		$italic.disabled = false
		$underline.disabled = false
		$TextEdit.grab_focus()


func _on_Button_pressed():
	var text = $TextEdit.text
	$TextEdit.visible = false
	$TextEdit.readonly = true
	$RichTextLabel.bbcode_text = text
	$RichTextLabel.visible = true
	$save.disabled = true
	$image.disabled = true
	$bold.disabled = true
	$italic.disabled = true
	$underline.disabled = true


func _on_Button2_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	$TextEdit.insert_text_at_cursor("[img]"+path+"[/img]")
	actual_text = $TextEdit.text


func _on_bold_pressed():
	
	var text
	
	if $TextEdit.is_selection_active():
		text = $TextEdit.get_selection_text()
		$TextEdit.cut()
	else:
		text = ""
	$TextEdit.insert_text_at_cursor("[b]"+text+"[/b]")
	actual_text = $TextEdit.text


#func _on_italic_pressed():
#	$TextEdit.insert_text_at_cursor("[img]"+path+"[/img]")
#	actual_text = $TextEdit.text
#
#
#func _on_underline_pressed():
#	$TextEdit.insert_text_at_cursor("[img]"+path+"[/img]")
#	actual_text = $TextEdit.text
