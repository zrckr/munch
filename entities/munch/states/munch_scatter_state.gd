extends State

@export_range(1, 400, 1, 'suffix:px/s') var acceleration_speed
@export var lostbox: CollisionBox

@export_group('Munch Dependencies')
@export var munch: Entity
@export var munch_animations: EntityAnimations
@export var munch_blackboard: MunchBlackboard


func _ready() -> void:
	lostbox.body_exited.connect(on_lostbox_body_exited)


func on_lostbox_body_exited(exited_entity: Entity) -> void:
	if exited_entity in munch_blackboard.chasing_entities:
		munch_blackboard.chasing_entities.erase(exited_entity)


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Frightened':
			if munch_blackboard.chasing_entities.is_empty():
				state_machine.transition_to(&'Scatter')


func begin(_kwargs := {}) -> void:
	munch_blackboard.generate_random_target_position()


func act(delta: float) -> void:
	var total_munchies = get_tree().get_nodes_in_group(Entity.Group.MUNCH)
	var movement_speed = munch.properties.speed / len(total_munchies)
	var movement_amount = movement_speed / munch.properties.speed
	
	var target_direction = munch.global_position.direction_to(munch_blackboard.target_position)
	var target_velocity = target_direction * movement_speed
	
	munch_animations.play('default', linear(movement_amount))
	munch_animations.look_at_lerp(munch_blackboard.target_position, 0.1)
	
	munch.velocity = munch.velocity.lerp(target_velocity, acceleration_speed * delta)
	munch.move_and_slide()
	
	var target_distance = munch.global_position.distance_to(munch_blackboard.target_position)
	if target_distance <= 1.0:
		state_machine.transition_to(&'Wait')


func linear(x: float) -> float:
	return (1.75 - 0.25 * x)
