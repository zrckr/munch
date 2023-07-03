extends EntityAction


func _on_lostbox_body_exited(exited_entity: Entity) -> void:
	if exited_entity in state.chasing_entities:
		state.chasing_entities.erase(exited_entity)


func _transition_attempts() -> void:
	match state.action:
		&'Frightened':
			if state.chasing_entities.is_empty():
				state.action = &'Scatter'


func _begin() -> void:
	state.generate_random_target_position()


func _act(_delta: float) -> void:
	var total_munchies = get_tree().get_nodes_in_group(Entity.Group.MUNCH)
	var movement_speed = properties.speed / len(total_munchies)
	var movement_amount = movement_speed / properties.speed
	
	state.facing_direction = entity.global_position.direction_to(state.target_position)
	var target_velocity = state.facing_direction * movement_speed
	
	animations.default(movement_amount)
	animations.rotate_towards(state.target_position)
	
	entity.velocity = entity.velocity.lerp(target_velocity, 0.1)
	entity.move_and_slide()
	
	var target_distance = entity.global_position.distance_to(state.target_position)
	if target_distance <= 1.0:
		state.action = &'Wait'


func _is_action_active() -> bool:
	return state.action == &'Scatter'
