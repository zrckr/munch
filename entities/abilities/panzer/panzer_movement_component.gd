extends MovementComponent

const ROTATION_FACTOR := 2.5


func _physics_process(delta: float) -> void:
	var rotation_direction = Input.get_axis('left', 'right')
	var velocity = _entity.transform.y * Input.get_axis('up', 'down') * _current_speed
	
	_entity.rotation += rotation_direction * ROTATION_FACTOR * delta
	_entity.velocity = velocity
	_entity.move_and_slide()

	_current_direction = _entity.transform.y
	if not velocity.is_zero_approx():
		_entity.animation_component.play_default()
