extends Tree

#############
###SIGNALS###
#############

signal treeitem_dropped


###############
###VARIABLES###
###############

###PRELOAD###

var dosis_tree = "res://Assets/themes/Dosis_Tree.tres"
var blank_icon = "res://Assets/png/blank.png"

###ONREADY###

onready var popup = get_node("Popup")

###VARIABLES###

#Tree Dictionary
var tree_data = {}

#TreeItems
var root #The Tree root


###############
###FUNCTIONS###
###############

func _ready():
	#Init tree
	root = create_item()
	root.set_meta("UniqueID", GLOBAL._generate_id(root))
	tree_data["Root"] = root.get_meta("UniqueID")
	
	#Debug#
	var par = _create_item()
	_create_item()
	_create_item(par)
	var par2 = _create_item(par)
	_create_item(par2)
	var par3 = _create_item(par2)
	_create_item(par3)
	#######
	
	_update_tree_data(0)
	_update_tree()


###DRAG&DROP###
# warning-ignore:unused_argument
func get_drag_data(pos):
	
	var item = get_selected()
	
	# Use a label as drag preview
	var prev = Label.new()
	var dostheme = Theme.new()
	dostheme.default_font = load(dosis_tree)
	prev.set_theme(dostheme)
	prev.text = "     " + item.get_text(0)
	
	set_drag_preview(prev)
	
	# Return item as drag data
	return item
# warning-ignore:unused_argument
func can_drop_data(pos, data):
	
	set_drop_mode_flags(DROP_MODE_INBETWEEN | DROP_MODE_ON_ITEM)
	
	return typeof(data) == TYPE_OBJECT
func drop_data(pos, data):
	
	var shift = int(get_drop_section_at_position(pos))
	var to_item = get_item_at_position(pos)
	
	_move_item(data, to_item, shift)
	
	set_drop_mode_flags(DROP_MODE_DISABLED)
###############


#Adding an Item
func _create_item(parent = null, idx = -1, cellmode = 0, i_name = "New Item", icon = null):
	
	#Variables
	var new_item
	
	#Assigning parent
	if parent: #Parent is assigned
		new_item = create_item(parent)
	elif get_selected(): #Parent will be selected item
		new_item = create_item(get_selected())
	else: #Just add it as Root child
		new_item = create_item()
	
	#Checking CELLMODE
	match cellmode:
		0: #Simple
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_ICON)
			new_item.set_icon(0, load(blank_icon))
		1: #Checkbox
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		2: #Icon
			new_item.set_cell_mode(0, TreeItem.CELL_MODE_ICON)
			new_item.set_icon(0, load(icon))
	
	#Setting Text & Meta
	new_item.set_text(0, " " + i_name)
	new_item.set_meta("UniqueID", GLOBAL._generate_id(new_item))
	
	_update_tree_data(0)
	
	return new_item

#Moving a TreeItem
func _move_item(item, to_item, shift):
	
	#Creating local variables
	var new_item
	var has_childs
	var childs
	var item_data = {"name":item.get_text(0), "mode":item.get_cell_mode(0), "unique_id":item.get_meta("UniqueID"), "sync_id":item.get_meta("SyncID")}
	
	#Debug
	print("--Item " + str(item) + " Data--")
	print(item_data)
	
	if item.get_children():
		childs = _get_children(item)
		has_childs = true
	
	#Removing item from tree
	item.get_parent().remove_child(item)
	
	#Checking where to drop
	if shift == -1: #Above Item
		new_item = create_item(to_item.get_parent())
	
	elif shift == 0: #On Item
		new_item = create_item(to_item)
	
	elif shift == 1: #Below Item
		new_item = create_item(to_item)
	
	#Reskin the item
	new_item.set_cell_mode(0, item_data["mode"])
	new_item.set_text(0, item_data["name"])
	new_item.set_meta("UniqueID", item_data["unique_id"])
	new_item.set_meta("SyncID", item_data["sync_id"])
	
	#Re-adding childs
	if has_childs:
		_add_childs(new_item, childs)
	
	#Updating ref
	emit_signal("treeitem_dropped", new_item)

#Deleting item
func _delete_item(item):
	var id = item.get_meta("UniqueID")
	root.remove_child(item)
	GLOBAL._delete_id(id)

#Getting a TreeItem's childs
func _get_children(target_item):
	
	var item_childs = {} #UniqueID:[child_idx, name, cellmode, SyncID, childs]
	
	if target_item.get_children(): #Ensure there IS children
		
		var current_child = target_item.get_children()
		var child_idx = 0
		
		#Debug#
		print("--Item " + str(target_item) + "'s Children--")
		print("-First Child")
		print(str(current_child) + " : " + str(current_child.get_meta("UniqueID")))
		#######
		
		var still_have_childs = true
		
		#Getting all childs
		while still_have_childs:
			
			#Getting child's data
			if current_child.get_children(): #Getting the child's children
				if current_child.has_meta("SyncID"):
					item_childs[current_child.get_meta("UniqueID")] = [child_idx, current_child.get_text(0), current_child.get_cell_mode(0), current_child.get_meta("SyncID"), _get_children(current_child)]
				else:
					item_childs[current_child.get_meta("UniqueID")] = [child_idx, current_child.get_text(0), current_child.get_cell_mode(0), null, _get_children(current_child)]
			
			else: #Item don't have children
				if current_child.has_meta("SyncID"):
					item_childs[current_child.get_meta("UniqueID")] = [child_idx, current_child.get_text(0), current_child.get_cell_mode(0), current_child.get_meta("SyncID"), null]
				else:
					item_childs[current_child.get_meta("UniqueID")] = [child_idx, current_child.get_text(0), current_child.get_cell_mode(0), null, null]
			
			#Getting next child in hierarchy
			if current_child.get_next(): #There is more TreeItems
				
				if current_child.get_next().get_parent() == current_child.get_parent(): #There is more siblings
					
					child_idx += 1
					current_child = current_child.get_next()
					
					#Debug#
					print("-Child " + str(child_idx))
					print(str(current_child) + " : " + str(current_child.get_meta("UniqueID")) + " | IDX : " + str(child_idx))
					#######
				
				else: #Next TreeItem isn't a sibling
					still_have_childs = false
					break
			
			else: #Aren't anymore TreeItems
				still_have_childs = false
				break
		
		#Debug#
		print("--Item's Child Data--")
		print(item_childs)
		#######
	
	return item_childs

#Adding childs from a dictionary
func _add_childs(item, childs):
	
	var hierarchy = _sort(childs)
	var idx = 0
	
	var still_more_childs = true
	
	while still_more_childs:
		
		var current_child = hierarchy[idx]
		current_child = current_child[0]
		var 
	

#Updating tree_data
func _update_tree_data(update_mode = 0, file_path = null):
	
	if update_mode == 0: #Update tree dictionary
		#For saving data
		tree_data["Root"] = root.get_meta("UniqueID")
		tree_data = _get_children(root)
		tree_data["Root"] = root.get_meta("UniqueID")
	
	elif update_mode == 1: #Update tree from file
		#For restoring data
		var file = File.new()
		file.open(file_path, 1)
		var data = file.get_as_text()
		tree_data = parse_json(data)
		_update_tree()
	
	elif update_mode == 2: #Update tree from tree_data
		#If tree_data is modified somewhere
		_update_tree()

#Updating tree
func _update_tree():
	
	if tree_data.size() > 1: #Tree has at least 1 item
		
		#Clearing tree for repopulating it
		clear()
		root = create_item()
		root.set_meta("UniqueID", tree_data["Root"])
		GLOBAL._update_id(tree_data["Root"], root)
		
		#Getting childs
		var childs = tree_data.duplicate(true)
		childs.erase("Root")
		
		#Debug#
		print("-Childs Data")
		print(childs)
		#######
		
		#Repopulating
		_add_childs(root, childs)
	
	elif tree_data.has("Root"): #No items but root exists
			var root_id = tree_data["Root"]
			clear()
			root = create_item()
			root.set_meta("UniqueID", root_id)
			GLOBAL.pairs_obj_id[root_id] = root
	
	else: #No root
		root = create_item()
		root.set_meta("UniqueID", GLOBAL._generate_id(root))

#Sort tree_data for easy use
func _sort(dict):
	
	#Variables
	var data = dict.duplicate(true)
	var sorted_keys = {} #Idx:[UniqueID, [childs]]
	var sorting_keys = []
	var keys = []
	var has_childs = []
	
	#Erasing Root
	if data.has("Root"):
		data.erase("Root")
	
	keys = data.keys()
	sorting_keys.resize(keys.size())
	has_childs.resize(keys.size())
	
	#Iterating over data
	for key in keys:
		
		var idx
		var key_data = data[key]
		
		idx = data[key] #Getting idx of item
		idx = idx[0]
		
		sorting_keys[idx] = key #Sorting item
		
		if key_data[4] != null: #Checking if has children
			has_childs[idx] = true
		else:
			has_childs[idx] = false
	
	var idx = 0
	
	#Throwing all data into a dictionary
	while idx < keys.size():
		
		if has_childs[idx]:
			var childs = data[sorting_keys[idx]] #Data of item [idx]
			childs = childs[4] #Childs dictionary of item [idx]
			sorted_keys[idx] = [sorting_keys[idx], _sort(childs)]
		
		else:
			sorted_keys[idx] = [sorting_keys[idx], null]
		
		idx += 1
	
	return sorted_keys


######################
###SIGNAL FUNCTIONS###
######################

#Tree Right-Click Menu
# warning-ignore:unused_argument
func _on_Tree_item_rmb_selected(position):
	var pos = Rect2(get_global_mouse_position(), Vector2(50, 50))
	popup.popup(pos)

#Right-Click Menu Config
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

