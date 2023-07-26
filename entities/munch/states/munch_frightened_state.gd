extends State

@export_range(1, 400, 1, 'suffix:px/s') var acceleration_speed: float
@export_range(-45, 45, 1, 'degrees') var mininum_deviation_angle: int
@export_range(-45, 45, 1, 'degrees') var maximum_deviation_angle: int
@export var detection_box: CollisionBox

@export_group('Munch Dependencies')
@export var munch: Entity
@export var munch_animations: EntityAnimations
@export var munch_blackboard: MunchBlackboard


func _ready() -> void:
	detection_box.body_entered.connect(on_detection_box_body_entered)


func on_detection_box_body_entered(entered_entity: Entity) -> void:
	if not entered_entity in munch_blackboard.chasing_entities:
		munch_blackboard.chasing_entities.push_front(entered_entity)


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Wait', &'Scatter':
			if len(munch_blackboard.chasing_entities) > 0:
				state_machine.transition_to(&'Frightened')


func act(delta: float) -> void:
	var offset_angle = deg_to_rad(randi_range(mininum_deviation_angle, maximum_deviation_angle))
	
	var target_direction = find_nearest_direction().rotated(offset_angle)
	var target_velocity = target_direction * munch.properties.speed
	
	munch_blackboard.target_position = munch.global_position + target_velocity
	munch_animations.look_at_lerp(munch_blackboard.target_position, 0.1)
	
	munch.velocity = munch.velocity.lerp(target_velocity, acceleration_speed * delta)
	munch.move_and_slide()


func find_nearest_direction() -> Vector2:
	var distance := INF
	var position := Vector2.ZERO
	
	for chasing_entity in munch_blackboard.chasing_entities:
		var chasing_distance = munch.global_position.distance_to(chasing_entity.global_position)
		if chasing_distance <= distance:
			distance = chasing_distance
			position = chasing_entity.global_position
	
	return position.direction_to(munch.global_position)
