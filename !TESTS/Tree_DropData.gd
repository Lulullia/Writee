extends TreeItem

var dosis_tree = "res://Assets/themes/Dosis_Tree.tres"

func get_drag_data(pos):
	
	# Use a label as drag preview
	var prev = Label.new()
	prev.font = load(dosis_tree)
	prev.text = get_text(0)
	
	set_drag_preview(prev)
	
	# Return item as drag data
	return self


func can_drop_data(pos, data):
	return typeof(data) == TYPE_COLOR


func drop_data(pos, data):
#	color=data
	pass