class_name HooverBlackboard
extends Node

@export_group('Hoover Dependencies')
@export var hoover: Entity
@export var state_machine: StateMachine


var suction_amount: int:
	get:
		return suction_amount
	set(value):
		suction_amount = value
		suction_callback.call(value)

var can_shoot: bool:
	get: return suction_amount > 0

var empty_capacity: bool:
	get: return suction_amount == 0

var enough_capacity: bool:
	get: return suction_amount >= 0

var suction_callback := Callable()

var suction_tweens := {}

var facing_direction := Vector2.DOWN


func _physics_process(_delta: float) -> void:
	match state_machine.current_state.name:
		&'Move':
			if Inputs.has_movement:
				facing_direction = Inputs.movement
		&'Attack', &'Suck':
			hoover.velocity = hoover.velocity.move_toward(Vector2.ZERO, 8)
			hoover.move_and_slide()


func get_suction_angle() -> float:
	var direction = Vector2.DOWN
	
	if facing_direction.x > 0:
		direction = Vector2.RIGHT
	if facing_direction.x < 0:
		direction =  Vector2.LEFT
	if facing_direction.y < 0:
		direction =  Vector2.UP
	if facing_direction.y > 0:
		direction =  Vector2.DOWN
	
	return direction.angle() - Math.HALF_PI
