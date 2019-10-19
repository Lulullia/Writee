extends Control

#############
###SIGNALS###
#############



###############
###VARIABLES###
###############

###ONREADY###
onready var line_edit = get_node("Panel/HC/LineEdit")
onready var option_button = get_node("Panel/HC/Options")
onready var option_popup = get_node("Panel/HC/Options/PopupMenu")

###############
###FUNCTIONS###
###############

func _ready():
	
	option_button.get_popup().connect("id_pressed", self, "_on_options_pressed")

######################
###SIGNAL FUNCTIONS###
######################

func _on_LineEdit_text_entered(new_text):
	line_edit.set_text(new_text)
	line_edit.release_focus()
	option_button.set_visible(false)

func _on_Panel_mouse_entered():
	option_button.set_visible(true)

func _on_Panel_mouse_exited():
	if get_focus_owner() != line_edit:
		option_button.set_visible(false)

func _on_LineEdit_focus_entered():
	option_button.set_visible(true)

func _on_options_pressed(id):
	match id:
		0: #Delete
			queue_free()
