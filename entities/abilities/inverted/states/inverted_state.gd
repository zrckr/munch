extends State

@export_group('Inverted Dependencies')
@export var inverted: Entity

var display_system: DisplaySystem:
	get: return get_tree().get_first_node_in_group(System.Group.DISPLAY)


func begin(_kwargs := {}) -> void:
	if display_system:
		display_system.viewport_scale = Vector2.ONE * -1.0


func end() -> void:
	if display_system:
		display_system.viewport_scale = Vector2.ONE


func is_action_active() -> bool:
	return not inverted.is_queued_for_deletion()
