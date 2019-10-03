extends Control

#############
###SIGNALS###
#############

signal wanna_save


###############
###VARIABLES###
###############

###ONREADY###

onready var rich_text = get_node("Env/RichText")
onready var text_edit = get_node("Env/TextEdit")
onready var buttons = get_node("Env/Buttons")

###VARIABLES###

var actual_text setget set_actual_text, get_actual_text


###############
###FUNCTIONS###
###############

#Init
func _ready():
	
	#Setting FileDialog Filers
	$FileDialog.call_deferred("set_filters", PoolStringArray(["*.png ; PGN Images",
											"*.jpg ; JPG Images",
											"*.jpeg ; JPEG Images"]))
	
	#Initializing text size
	_on_size_value_changed(20)


#Actual_text setget
func set_actual_text(value):
	actual_text = value
	text_edit.call_deferred("set_text", value)
	rich_text.call_deferred("set_bbcode", value)
func get_actual_text():
	return actual_text


#Syncing scrollbar
func set_scrollbar_value(target):
	
	var scrollbar_value
	
	match target:
		
		"TextEdit":
			scrollbar_value = rich_text.get_child(0).get_as_ratio()
			text_edit.get_child(1).set_as_ratio(scrollbar_value)
		
		"RichLabel":
			scrollbar_value = text_edit.get_child(1).get_as_ratio()
			rich_text.get_child(0).set_as_ratio(scrollbar_value)


######################
###SIGNAL FUNCTIONS###
######################


func _on_RichText_gui_input(event):
	
	if event.is_action_pressed("left_click"):
		rich_text.set_visible(false)
		actual_text = rich_text.get_bbcode()
		
		text_edit.set_text(actual_text)
		text_edit.set_readonly(false)
		text_edit.set_visible(true)
		
		set_scrollbar_value("TextEdit")
		
		for button in buttons.get_children():
			if button.has_method("set_disabled"):
				button.set_disabled(false)
		
		text_edit.grab_focus()


###Buttons Functions###

func _on_save_pressed():
	
	actual_text = text_edit.get_text()
	text_edit.set_visible(false)
	text_edit.set_readonly(true)
	rich_text.set_bbcode(actual_text)
	rich_text.set_visible(true)
	
	set_scrollbar_value("RichLabel")
	
	for button in buttons.get_children():
		if button.has_method("set_disabled"):
			button.set_disabled(true)
	
	emit_signal("wanna_save")


func _on_image_pressed():
	$FileDialog.popup()

func _on_FileDialog_file_selected(path):
	text_edit.call_deferred("insert_text_at_cursor", "[img]"+path+"[/img]")
	actual_text = text_edit.get_text()


func _on_bold_pressed():
	
	var text
	
	if text_edit.is_selection_active():
		text = text_edit.get_selection_text()
		text_edit.cut()
	else:
		text = ""
	text_edit.insert_text_at_cursor("[b]"+text+"[/b]")
	actual_text = text_edit.get_text()

func _on_italic_pressed():
	
	var text
	
	if text_edit.is_selection_active():
		text = text_edit.get_selection_text()
		text_edit.cut()
	else:
		text = ""
	text_edit.insert_text_at_cursor("[i]"+text+"[/i]")
	actual_text = text_edit.get_text()

func _on_underline_pressed():
	
	var text
	
	if text_edit.is_selection_active():
		text = text_edit.get_selection_text()
		text_edit.cut()
	else:
		text = ""
	text_edit.insert_text_at_cursor("[u]"+text+"[/u]")
	actual_text = text_edit.get_text()


func _on_size_value_changed(value):
	for font in ["mono_font", "bold_italics_font", "bold_font", "italics_font", "normal_font"]:
		rich_text.get_font(font).set_size(value)
	text_edit.get_font("font").set_size(value)

