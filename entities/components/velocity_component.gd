@icon('res://editor/icons/velocity.png')
class_name VelocityComponent
extends Node

@export
var entity: Entity

@export_range(1, 400, 1, 'suffix:px/s')
var acceleration_speed: float

@export
var debug_mode: bool = false

var acceleration_multiplier := 1.0:
	get: return acceleration_multiplier
	set(value): acceleration_multiplier = clampf(value, 0.0, 1.0)

var velocity: Vector2


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			set_process(false)
			if OS.is_debug_build() and debug_mode:
				entity.draw.connect(_on_debug_draw)
				set_process(true)
		NOTIFICATION_PROCESS:
			entity.queue_redraw()


func move() -> void:
	entity.velocity = velocity
	entity.move_and_slide()


func accelerate_to_velocity(target_velocity: Vector2) -> void:
	var delta = get_physics_process_delta_time()
	var weight =  1.0 - exp(-acceleration_speed * acceleration_multiplier * delta)
	velocity = velocity.lerp(target_velocity, weight)


func accelerate_to_direction(target_direction: Vector2) -> void:
	accelerate_to_velocity(target_direction * entity.properties.speed)


func decelerate_to_zero() -> void:
	accelerate_to_velocity(Vector2.ZERO)


func apply_gravity(gravity: float) -> void:
	var delta = get_physics_process_delta_time()
	velocity = Vector2(velocity.x, velocity.y + gravity * delta)


func predict_intersection(source_node: Node2D, target_node: Node2D, source_speed: float) -> Vector2:
	var speed = velocity.length()
	var amount = source_speed / speed
	
	if absf(speed) < 1.0:
		return target_node.global_position
	
	var diff_amount = (source_node.global_position - target_node.global_position).length() / source_speed
	return target_node.global_position + velocity * diff_amount * amount


func _on_debug_draw() -> void:
	entity.draw_line(Vector2.ZERO, velocity, Color.CYAN, 2.0)
