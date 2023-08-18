@icon('res://editor/icons/node.png')
extends Node

var _display_system: DisplaySystem:
	get: return get_tree().get_first_node_in_group(System.Group.DISPLAY)


func _enter_tree() -> void:
	if _display_system:
		_display_system.viewport_scale = -Vector2.ONE


func _exit_tree() -> void:
	if _display_system:
		_display_system.viewport_scale = +Vector2.ONE
