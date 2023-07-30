extends State

@export_range(0.1, 10.0, 0.1)
var rotation_speed: float

@export_range(1, 400, 1, 'suffix:px/s')
var acceleration_speed: float

@export_group('State Dependencies')
@export var hitbox: CollisionBox

@export_group('BigBoy Dependencies')
@export var bigboy: Entity
@export var bigboy_animations: EntityAnimations


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Idle':
			if Inputs.has_movement:
				state_machine.transition_to(&'Move')


func begin(_kwargs := {}) -> void:
	hitbox.enable()


func act(delta: float) -> void:
	if Inputs.has_movement:
		var target_rotation = Inputs.movement.angle() - Math.HALF_PI
		bigboy.rotation = Math.rotate_to_angle(bigboy.rotation, target_rotation, rotation_speed * delta)
	
	var input_amount = Inputs.movement.length_squared()
	var target_velocity = bigboy.transform.y * input_amount * bigboy.properties.speed
	
	bigboy.velocity = bigboy.velocity.lerp(target_velocity, acceleration_speed * delta)
	bigboy.move_and_slide()
	
	var custom_speed = bigboy.velocity.length() / bigboy.properties.speed
	custom_speed = clampf(custom_speed * -1.0, -2.0, 2.0)
	bigboy_animations.play('rolling', custom_speed)


func end() -> void:
	hitbox.disable()
