extends State

@export_group('Panzer Dependencies')
@export var panzer: Entity
@export var panzer_animations: EntityAnimations


func transition_attempts() -> void:
	var not_attacking = state_machine.current_state.name != &'Attack'
	if not_attacking and Inputs.has_movement:
		state_machine.transition_to(&'Move')


func begin(_kwargs := {}) -> void:
	panzer_animations.play('move')


func act(_delta: float) -> void:
	if Inputs.has_movement:
		var target_angle = Inputs.movement.angle() + Math.HALF_PI
		panzer.rotation = target_angle
	
	var input_amount = Inputs.movement.length()
	var target_velocity = -panzer.transform.y * input_amount * panzer.properties.speed
	
	panzer.velocity = target_velocity
	panzer.move_and_slide()
