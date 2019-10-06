extends Control

#############
###SIGNALS###
#############

signal namebox_button_pressed

###############
###VARIABLES###
###############

###ONREADY###

#Containers
onready var space = get_node("Space")
#onready var tree_view = get_node("Container/Space/TreeView")
onready var tabbed_space = get_node("Space/TabMargin/TabContainer")
onready var text_input = get_node("TextInput")

#Nodes
onready var tree = get_node("Space/TreeView/Tree")

#Buttons
onready var add_item_button = get_node("Add_Item")
onready var tree_collapse_button = get_node("Space/TreeView/Collapse")

onready var namebox = get_node("TextInput/Namebox")
#onready var namebox_buttons = get_node("TextInput/Buttons")

###PRELOAD###

var writing_tab = "res://!TESTS/Writing_Tabs.tscn"

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
	#Add_Item_Button Signal Connecting
	add_item_button.get_popup().connect("id_pressed", self, "_on_AddItem_pressed")

func set_current_tab(id):
	is_tab_referenced = false
	tabbed_space.set_current_tab(id)

func save_text(tab): #Saving tab's text
	scenes[tab] = tab.get_scene_text()
	GLOBAL.text = scenes

func _show_hide_namebox(what): #Showing & Hiding namebox
	if what: #Show
		$Anim.play("ScreenShade")
		text_input.set_visible(true)
		namebox.grab_focus()
	else: #Hide
		$Anim.play_backwards("ScreenShade")
		text_input.set_visible(false)

######################
###SIGNAL FUNCTIONS###
######################

#Adding Item
func _on_AddItem_pressed(id):
	
	#Showing Namebox
	_show_hide_namebox(true)
	add_item_button.set_disabled(true)
	
	#When a button is pressed
	var action = yield(self, "namebox_button_pressed")
	
	if action: #Confirm pressed
		
		#Variables
		var new_item
		var new_item_name
		var new_tab = load(writing_tab).instance()
		var tab_index = tabbed_space.get_tab_count()
		
		#Getting name
		new_item_name = namebox.get_text()
		namebox.clear()
		
		#Creating Item
		if new_item_name == null || new_item_name == "" || new_item_name == " ":
			new_item = tree._create_item(null, -1, id, "New Scene")
		else: #Namebox isn't empty
			new_item = tree._create_item(null, -1, id, new_item_name)
		
		#Creating Tab
		tabbed_space.add_child(new_tab, true)
		set_current_tab(tab_index)
		new_tab = tabbed_space.get_current_tab_control()
		tabbed_space.set_tab_title(tab_index, new_item_name)
		new_tab.connect("wanna_save", self, "save_text")
		
		#Referencing
		var sync_id = GLOBAL._generate_id([new_item, new_tab])
		new_item.set_meta("SyncID", sync_id)
		new_tab.set_meta("SyncID", sync_id)
		
		scenes_ref[new_tab] = new_item
		save_text(new_tab)
		
		is_tab_referenced = true
		
		add_item_button.set_disabled(false)
		
		#Debug
		print("--Adding Item & Tab--")
		print("-New Item & New Tab")
		print([new_item, new_tab])
		print("-Sync ID")
		print(sync_id)
	
	else: #Cancel pressed
		add_item_button.set_disabled(false)

#TextInput Buttons
func _on_Confirm_pressed():
	_show_hide_namebox(false)
	emit_signal("namebox_button_pressed", true)
func _on_Cancel_pressed():
	_show_hide_namebox(false)
	emit_signal("namebox_button_pressed", false)

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
	var tab = GLOBAL.pairs_obj_id[cell.get_meta("SyncID")]
	tab = tab[1]
	tabbed_space.set_current_tab(tab.get_index())
# warning-ignore:unused_argument
func _on_TabContainer_tab_changed(_tab):
	if !is_tab_referenced:
		pass
	else:
		var tab = tabbed_space.get_current_tab_control()
		var sync_id = tab.get_meta("SyncID")
		var cell = GLOBAL.pairs_obj_id[sync_id]
		cell = cell[0]
		cell.select(0)
		tree.ensure_cursor_is_visible()

#Updating Ref when dropping
func _on_Tree_treeitem_dropped(item):
	scenes_ref[item.get_metadata(0)] = item

