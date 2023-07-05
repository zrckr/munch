extends EntityAction

@export_exp_easing('positive_only')
var acceleration_weight: float


func _on_detection_box_body_entered(entered_entity: Entity) -> void:
	if not state.target_entity:
		state.target_entity = entered_entity


func _act(_delta: float) -> void:
	state.target_entity = get_tree() \
		.get_first_node_in_group(Entity.Group.PLAYER) \
		as Entity
	
	if not state.target_entity:
		state.action = &'Idle'
		return
	
	var target_direction = entity.global_position.direction_to(state.target_entity.global_position)
	var target_velocity = target_direction * properties.speed
	
	state.facing_direction = Vector2i(target_direction.round())
	animations.move(state.facing_direction)
	
	entity.velocity = Math.smooth_stepv(entity.velocity, target_velocity, acceleration_weight)
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Chase'
