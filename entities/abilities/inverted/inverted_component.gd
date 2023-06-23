@icon('res://editor/icons/component.png')
class_name InvertedComponent
extends Node

var display_system: DisplaySystem:
	get: return get_tree().get_first_node_in_group(System.Group.DISPLAY)


func _enter_tree() -> void:
	if display_system:
		display_system.viewport_scale = Vector2.ONE * -1.0


func _exit_tree() -> void:
	if display_system:
		display_system.viewport_scale = Vector2.ONE
