extends Tree

signal treeitem_dropped

var dosis_tree = "res://Assets/themes/Dosis_Tree.tres"

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


func can_drop_data(pos, data):
	
	set_drop_mode_flags(DROP_MODE_INBETWEEN)
	
	return typeof(data) == TYPE_OBJECT


func drop_data(pos, data):
	
	var shift = int(get_drop_section_at_position(pos))
	
	if shift == 1 || shift == -1:
		
		var new_item
		var item = {"name":str(data.get_text(0)), "mode":data.get_cell_mode(0), "meta":data.get_metadata(0)}
		var target_item = get_item_at_position(pos)
		
		print("--Item Meta--")
		print(item)
		
		data.get_parent().remove_child(data)
		
		if shift == 1:
			new_item = create_item(target_item.get_parent())
		
		elif shift == -1:
			new_item = create_item(target_item.get_parent())
		
		new_item.set_cell_mode(0, item["mode"])
		new_item.set_text(0, item["name"])
		new_item.set_metadata(0, item["meta"])
		
		print("--New_Item Meta--")
		print("-Text")
		print(new_item.get_text(0))
		print("-Metadata")
		print(new_item.get_metadata(0))
		print("-Cellmode")
		print(new_item.get_cell_mode(0))
		
		#Updating ref
		emit_signal("treeitem_dropped", new_item)
	
	set_drop_mode_flags(DROP_MODE_DISABLED)


#func drop_data(position, item):
#    var to_item = get_item_at_position(position)
#    var shift = get_drop_section_at_position(position)
#    # shift == 0 if dropping on item, -1, +1 if in between
#
#    emit_signal('moved', item, to_item, shift)

#From there you should update your tree according to requested moved 
#signal from data which must determine the order of items (for this I 
#just clear all items and repopulate them). Note that the extended Tree 
#class should likely operate in tool mode if writing plugins for this 
#to work. You could embed your data in TreeItems with set_metadata per 
#column or set_meta per item for dragging and other purposes.


