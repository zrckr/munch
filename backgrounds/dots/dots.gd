extends Node

const OVERLAY_LERP_WEIGHT := 2.5

var player_entity: Entity:
	get:
		return get_tree().get_first_node_in_group(Entity.Group.PLAYER)

@onready
var texture: Polygon2D = $Texture

@onready
var overlay: Polygon2D = $Texture/Overlay


func _physics_process(delta: float) -> void:
	if player_entity:
		var start_position = overlay.global_position
		var end_position = player_entity.global_position
		overlay.global_position = start_position \
			.lerp(end_position, OVERLAY_LERP_WEIGHT * delta)
