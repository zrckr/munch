class_name Projectile
extends Area2D

@export_range(0, 500, 10, 'suffix:px/s')
var target_speed: float

@export_range(0.01, 1.0, 0.01, 'suffix:s')
var acceleration_time: float

var damage: int

var _current_speed: float


func _enter_tree() -> void:
	if is_zero_approx(target_speed):
		push_error('The target speed is set to zero')


func _physics_process(delta: float) -> void:
	if _current_speed < target_speed:
		_current_speed = move_toward(_current_speed, target_speed, acceleration_time)
	
	var direction = -transform.y.normalized()
	position += direction * target_speed * delta
