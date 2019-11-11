extends Control

###############
###VARIABLES###
###############

###ONREADY###

#Nothing Found
onready var noth_world = get_node("MainCont/PanelMargin/Panel/PanelCont/Tabs/Worlds/Nothing")
onready var noth_book = get_node("MainCont/PanelMargin/Panel/PanelCont/Tabs/Books/Nothing")
#Item Container
onready var item_world = get_node("MainCont/PanelMargin/Panel/PanelCont/Tabs/Worlds/Items")
onready var item_book = get_node("MainCont/PanelMargin/Panel/PanelCont/Tabs/Books/Items")

###PRELOAD###

#Book or World Item
var item = preload("res://ProjectManager/ProjectItem.tscn")

###CONSTANTS###

###ENUMS###

###VARIABLES###


###############
###FUNCTIONS###
###############

func _ready():
	pass
	#Getting the data
	var data = File.new()
	if data.file_exists("user://project_manager.wrt"):
		data.open("user://project_manager.wrt", 1)
		var projects = parse_json(data.get_as_text())
		data.close()
		#then the code for retrieving data
		noth_book.set_visible(false)
		item_book.set_visible(true)
		noth_world.set_visible(false)
		item_world.set_visible(true)
	
	else :
		noth_book.set_visible(true)
		item_book.set_visible(false)
		noth_world.set_visible(true)
		item_world.set_visible(false)


######################
###SIGNAL FUNCTIONS###
######################

