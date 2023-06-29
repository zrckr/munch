@icon('res://editor/icons/node.png')
class_name EntityState
extends CanvasItem

@onready
var entity := owner as Entity:
	get: return entity

var action: StringName:
	get:
		return action
	set(value):
		if action != value:
			last_action = action
			action = value

var last_action: StringName


func get_actions() -> Array[EntityAction]:
	var actions: Array[EntityAction] = []
	for node in get_children():
		if node is EntityAction:
			actions.push_back(node)
		else:
			push_warning("'%s' is not an EntityAction" % node.get_path())
	return actions
