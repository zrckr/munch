extends Node


func _enter_tree() -> void:
	var camera_2d := get_viewport().get_camera_2d()
	if camera_2d:
		camera_2d.zoom = Vector2.ONE * -1.0


func _exit_tree() -> void:
	var camera_2d := get_viewport().get_camera_2d()
	if camera_2d:
		camera_2d.zoom = Vector2.ONE
