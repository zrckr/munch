extends Node

@export
var minimum_global_position: Vector2

@export
var maximum_global_position: Vector2

@onready
var texture: Polygon2D = $Texture

@onready
var overlay: Polygon2D = $Texture/Overlay

@export
var overlay_lerp_weight := 2.5


func _physics_process(delta: float) -> void:
	var player := Game.get_player()
	if player:
		var start_position = overlay.global_position
		var end_position = player.global_position
		overlay.global_position = start_position \
			.lerp(end_position, overlay_lerp_weight * delta)
