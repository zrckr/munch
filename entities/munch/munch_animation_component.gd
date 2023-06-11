extends AnimationComponent

const ROTATION_FACTOR := 0.25

var _previous_position: Vector2


func _process(delta: float) -> void:
	_modulate_during_rtd()
	_play_default()
	_look_at_velocity_direction(delta)
	_previous_position = _entity.global_position


func _modulate_during_rtd() -> void:
	var ability = get_tree().get_first_node_in_group(Entity.Group.POSITIVE_ROLL)
	if not ability:
		ability = get_tree().get_first_node_in_group(Entity.Group.NEGATIVE_ROLL)
	
	if ability:
		_sprite.modulate.a = 0.25
	else:
		_sprite.modulate.a = 1.0


func _play_default() -> void:
	var current_moving_speed = _entity.velocity.length()
	var animation_speed = current_moving_speed / _properties.speed

	_player.play('default')
	_player.speed_scale = _linear_function(animation_speed)


func _look_at_velocity_direction(delta: float) -> void:
	if _previous_position.is_equal_approx(_entity.global_position):
		return
	
	var target_position = _entity.global_position + _entity.velocity * delta
	var angle_offset = (to_local(target_position) * scale).angle()
	
	angle_offset += PI / 2.0
	rotation = lerp(rotation, rotation + angle_offset, ROTATION_FACTOR)


func _linear_function(x: float) -> float:
	return 1.75 - 0.25 * x
