extends EntityAction

@export_range(0.1, 10.0, 0.1)
var rotation_amount: float


func _transition_attempts() -> void:
	var not_attacking = state.action != &'Attack'
	var has_input = not _get_input().is_zero_approx()
	if not_attacking and has_input:
		state.action = &'Move'


func _begin() -> void:
	animations.move()


func _act(_delta: float) -> void:
	state.facing_direction = Vector2i(-entity.transform.y.round())
	
	if not _get_input().is_zero_approx():
		var target_angle = _get_input().angle() + Math.HALF_PI
		entity.rotation = target_angle
	
	var input_amount = _get_input().length_squared()
	var target_velocity = -entity.transform.y * input_amount * properties.speed
	
	entity.velocity = target_velocity
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Move'


func _get_input() -> Vector2:
	return Input.get_vector('left', 'right', 'up', 'down')
