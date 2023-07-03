extends EntityAction

var _display_system: DisplaySystem:
	get: return get_tree().get_first_node_in_group(System.Group.DISPLAY)


func _begin() -> void:
	if _display_system:
		_display_system.viewport_scale = Vector2.ONE * -1.0


func _end() -> void:
	if _display_system:
		_display_system.viewport_scale = Vector2.ONE


func _is_action_active() -> bool:
	return not entity.is_queued_for_deletion()
