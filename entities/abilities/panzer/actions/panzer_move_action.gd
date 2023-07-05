extends EntityAction

@export_range(0.1, 10.0, 0.1)
var rotation_amount: float


func _transition_attempts() -> void:
	var not_attacking = state.action != &'Attack'
	if not_attacking and Inputs.has_movement:
		state.action = &'Move'


func _begin() -> void:
	animations.move()


func _act(_delta: float) -> void:
	state.facing_direction = Vector2i(-entity.transform.y.round())
	
	if Inputs.has_movement:
		var target_angle = Inputs.movement.angle() + Math.HALF_PI
		entity.rotation = target_angle
	
	var input_amount = Inputs.movement.length()
	var target_velocity = -entity.transform.y * input_amount * properties.speed
	
	entity.velocity = target_velocity
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Move'
