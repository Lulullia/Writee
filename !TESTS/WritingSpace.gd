extends Control

#############
###SIGNALS###
#############


###############
###VARIABLES###
###############

###ONREADY###

onready var space = get_node("Container/Space")
#onready var tree_view = get_node("Container/Space/TreeView")
onready var tabbed_space = get_node("Container/Space/TabMargin/TabContainer")

onready var tree = get_node("Container/Space/TreeView/Tree")
onready var tree_popup = get_node("Container/Space/TreeView/Tree/Popup")

onready var add_item_button = get_node("HBoxContainer/Add_Item")
onready var tree_collapse_button = get_node("Container/Space/TreeView/Collapse")
onready var namebox = get_node("HBoxContainer/Namebox")
onready var namebox_confirm = get_node("HBoxContainer/Confirm")

###PRELOAD###

var writing_tab = "res://!TESTS/Writing_Tabs.tscn"
var tree_item_script = "res://!TESTS/Tree_DropData.gd"

var tree_collapse_icon = [preload("res://Assets/png/collapse.png"),
							preload("res://Assets/png/collapsed.png")]

###VARIABLES###

var scenes_ref = {} #Dictionary that contains refs [tab-cell]
var scenes = {} #Dictionary that contains the texts [tab-scene_text]

var is_tab_referenced = false

###############
###FUNCTIONS###
###############

func _ready():
	#Init Tree
	var root = tree.create_item()
	root.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
	
	#Add Item Button Signal Connecting
	add_item_button.get_popup().connect("id_pressed", self, "_on_AddItem_pressed")

func set_current_tab(id):
	is_tab_referenced = false
	tabbed_space.set_current_tab(id)

func save_text(tab): #Saving tab's text
	scenes[tab] = tab.get_scene_text()
	GLOBAL.text = scenes

######################
###SIGNAL FUNCTIONS###
######################

#Adding Item
func _on_AddItem_pressed(id):
	
	#Variables
	var new_item
	var new_item_name
	var new_tab = load(writing_tab).instance()
	var tab_index = tabbed_space.get_tab_count()
	
	#Showing Namebox
	$Anim.play("ScreenShade")
	namebox.set_visible(true)
	namebox_confirm.set_visible(true)
	
	#When Confirm is pressed
	while true:
		yield(namebox_confirm, "pressed")
		if namebox.get_text() != "" || namebox.get_text() != " ":
			break
	new_item_name = namebox.get_text()
	namebox.clear()
	
	#Creating Item
	if tree.get_selected():
		new_item = tree.create_item(tree.get_selected())
	else:
		new_item = tree.create_item()
	tabbed_space.add_child(new_tab, true)
	set_current_tab(tab_index)
	new_tab = tabbed_space.get_current_tab_control()
	
	#Attaching Drag-n-Drop Script to new_item
	new_item.set_script(tree_item_script)
	
	#Checking ID
	match id:
		0: #Simple
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
		1: #Checkbox
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		2: #Icon
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
	
	#Setting Text
	new_item.set_text(0, " " + new_item_name)
	tabbed_space.set_tab_title(tab_index, new_item_name)
	
	#Connecting Saving Signal
	new_tab.connect("wanna_save", self, "save_text")
	
	#Referencing
	new_item.set_metadata(0, new_tab)
	scenes_ref[new_tab] = new_item
	save_text(new_tab)
	
	is_tab_referenced = true
	
	print(scenes_ref)
	print(scenes)

#Confirm Name
func _on_Confirm_pressed():
	if namebox.get_text() != "" || namebox.get_text() != " ":
		$Anim.play_backwards("ScreenShade")
		namebox.set_visible(false)
		namebox_confirm.set_visible(false)

#Clamp Dragging
func _on_Space_dragged(offset):
	if offset < -400:
		offset = -400
	elif offset > 134:
		offset = 134
	space.set_split_offset(offset)

#Tree Collapsing
func _on_Collapse_toggled(button_pressed):
	if button_pressed: #Collapsed
		tree_collapse_button.set_button_icon(tree_collapse_icon[1])
		$Tween.interpolate_property(space, "split_offset", space.get_split_offset(), -800, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.start()
		space.set_dragger_visibility(SplitContainer.DRAGGER_HIDDEN)
	else: #Expanded
		tree_collapse_button.set_button_icon(tree_collapse_icon[0])
		$Tween.interpolate_property(space, "split_offset", space.get_split_offset(), -300, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		space.set_dragger_visibility(SplitContainer.DRAGGER_VISIBLE)

#Cell & Tab Selection Syncing
func _on_Tree_cell_selected():
	var cell = tree.get_selected()
	var tab = cell.get_metadata(0)
	tabbed_space.set_current_tab(tab.get_index())
# warning-ignore:unused_argument
func _on_TabContainer_tab_changed(s_tab):
	if !is_tab_referenced:
		pass
	else:
		var tab = tabbed_space.get_current_tab_control()
		var cell = scenes_ref[tab]
		cell.select(0)
		tree.ensure_cursor_is_visible()

#Tree Right-Click Menu
# warning-ignore:unused_argument
func _on_Tree_item_rmb_selected(position):
	var pos = Rect2(get_global_mouse_position(), Vector2(50, 50))
	tree_popup.popup(pos)

func _on_Popup_id_pressed(ID):
	
	match ID:
		0: #Rename
			pass
		1: #Add Child
			pass
		2: #Add Sibling
			pass
		3: #Change to
			pass
		4: #Delete
			pass













