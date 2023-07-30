extends State

@export_range(0.1, 10.0, 0.1)
var rotation_speed: float

@export_group('Panzer Dependencies')
@export var panzer: Entity
@export var panzer_animations: EntityAnimations


func transition_attempts() -> void:
	var not_attacking = state_machine.current_state.name != &'Attack'
	if not_attacking and Inputs.has_movement:
		state_machine.transition_to(&'Move')


func begin(_kwargs := {}) -> void:
	panzer_animations.play('move')


func act(delta: float) -> void:
	if Inputs.has_movement:
		var target_rotation = Inputs.movement.angle() + Math.HALF_PI
		panzer.rotation = Math.rotate_to_angle(panzer.rotation, target_rotation, rotation_speed * delta)
	
	var input_amount = Inputs.movement.length()
	var target_velocity = -panzer.transform.y * input_amount * panzer.properties.speed
	
	panzer.velocity = target_velocity
	panzer.move_and_slide()
