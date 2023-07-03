extends EntityAction

@export_exp_easing('positive_only')
var acceleration_weight: float

@export_range(-45, 45, 1, 'degrees')
var mininum_deviation_angle: int

@export_range(-45, 45, 1, 'degrees')
var maximum_deviation_angle: int


func _on_detectionbox_body_entered(entered_entity: Entity) -> void:
	if not entered_entity in state.chasing_entities:
		state.chasing_entities.push_front(entered_entity)


func _transition_attempts() -> void:
	match state.action:
		&'Wait', &'Scatter':
			if len(state.chasing_entities) > 0:
				state.action = &'Frightened'


func _act(_delta: float) -> void:
	var offset_angle = deg_to_rad(randi_range(mininum_deviation_angle, maximum_deviation_angle))
	state.facing_direction = _find_nearest_direction().rotated(offset_angle)
	
	var target_velocity = state.facing_direction * properties.speed
	state.target_position = entity.global_position + target_velocity
	
	animations.rotate_towards(state.target_position)
	entity.velocity = entity.velocity.lerp(target_velocity, acceleration_weight)
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Frightened'


func _find_nearest_direction() -> Vector2:
	var distance := INF
	var position := Vector2.ZERO
	
	for chasing_entity in state.chasing_entities:
		var chasing_distance = entity.global_position.distance_to(chasing_entity.global_position)
		if chasing_distance <= distance:
			distance = chasing_distance
			position = chasing_entity.global_position
	
	return position.direction_to(entity.global_position)
