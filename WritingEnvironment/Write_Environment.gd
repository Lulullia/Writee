extends Control

var actual_text setget set_actual_text, get_actual_text


func set_actual_text(value):
	actual_text = value
	$TextEdit.call_deferred("set_text", value)
	$RichTextLabel.call_deferred("set_bbcode", value)

func get_actual_text():
	return actual_text

func _ready():
	$FileDialog.call_deferred("set_filters", PoolStringArray(["*.png ; PGN Images",
											"*.jpg ; JPG Images",
											"*.jpeg ; JPEG Images"]))
	_on_SpinBox_value_changed(20)


func set_scrollbar_value(target):
	
	var scrollbar_value
	match target:
		"TextEdit":
			scrollbar_value = $RichTextLabel.get_child(0).get_as_ratio()
			$TextEdit.get_child(1).call_deferred("set_as_ratio", scrollbar_value)
		
		"RichLabel":
			scrollbar_value = $TextEdit.get_child(1).get_as_ratio()
			$RichTextLabel.get_child(0).call_deferred("set_as_ratio", scrollbar_value)


func _on_RichTextLabel_gui_input(event):
	
	if event.is_action_pressed("left_click"):
		$RichTextLabel.set_deferred("visible", false)
		actual_text = $RichTextLabel.get_bbcode()
		
		$TextEdit.call_deferred("set_text", actual_text)
		$TextEdit.set_deferred("readonly", false)
		$TextEdit.set_deferred("visible", true)
		
		set_scrollbar_value("TextEdit")
		
		$save.set_deferred("disabled", false)
		get_tree().set_group("edition_buttons", "disabled", false)
		
		$TextEdit.call_deferred("grab_focus")


func _on_Button_pressed():
	
	var text = $TextEdit.text
	$TextEdit.set_deferred("visible", false)
	$TextEdit.set_deferred("readonly", true)
	$RichTextLabel.call_deferred("set_bbcode", text)
	$RichTextLabel.set_deferred("visible", true)
	set_scrollbar_value("RichLabel")
	$save.set_deferred("disabled", true)
	get_tree().set_group("edition_buttons", "disabled", true)


func _on_Button2_pressed():
	$FileDialog.call_deferred("popup")


func _on_FileDialog_file_selected(path):
	$TextEdit.call_deferred("insert_text_at_cursor", "[img]"+path+"[/img]")
	actual_text = $TextEdit.get_text()


func _on_bold_pressed():
	
	var text
	
	if $TextEdit.is_selection_active():
		text = $TextEdit.get_selection_text()
		$TextEdit.call_deferred("cut")
	else:
		text = ""
	$TextEdit.call_deferred("insert_text_at_cursor", "[b]"+text+"[/b]")
	actual_text = $TextEdit.get_text()


func _on_italic_pressed():
	
	var text
	
	if $TextEdit.is_selection_active():
		text = $TextEdit.get_selection_text()
		$TextEdit.call_deferred("cut")
	else:
		text = ""
	$TextEdit.call_deferred("insert_text_at_cursor", "[i]"+text+"[/i]")
	actual_text = $TextEdit.get_text()


func _on_underline_pressed():
	
	var text
	
	if $TextEdit.is_selection_active():
		text = $TextEdit.get_selection_text()
		$TextEdit.call_deferred("cut")
	else:
		text = ""
	$TextEdit.call_deferred("insert_text_at_cursor", "[u]"+text+"[/u]")
	actual_text = $TextEdit.get_text()


func _on_SpinBox_value_changed(value):
	for font in ["mono_font", "bold_italics_font", "bold_font", "italics_font", "normal_font"]:
		$RichTextLabel.get_font(font).call_deferred("set_size", value)
	$TextEdit.get_font("font").call_deferred("set_size", value)
