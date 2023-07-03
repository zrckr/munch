extends EntityAnimations

@export_range(0, 1, 0.01)
var rotation_factor: float


func modulate_towards(alpha: float) -> void:
	_sprite.modulate.a = lerpf(_sprite.modulate.a, alpha, 0.25)


func rotate_towards(target: Vector2) -> void:
	var angle_offset = (to_local(target) * scale).angle()
	angle_offset += PI / 2.0
	rotation = lerp(rotation, rotation + angle_offset, rotation_factor)


func default(speed_scale: float) -> void:
	_animation_player.play('default')
	_animation_player.speed_scale = (1.75 - 0.25 * speed_scale)
