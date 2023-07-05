extends EntityAction

@export
var bullet_projectile: PackedScene

@export_flags_2d_physics
var bullet_collision_layer: int

@export_flags_2d_physics
var bullet_collision_mask: int

@onready
var _muzzle_rotator: Node2D = $MuzzleRotator

@onready
var _muzzle_marker: Marker2D= $MuzzleRotator/MuzzleMarker

@onready
var _reload_timer: Timer = $ReloadTimer

@onready
var _attack_box: CollisionBox = $AttackBox


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_find_nearest_target_body()


func _find_nearest_target_body() -> void:
	var bodies = _attack_box.get_overlapping_bodies().duplicate()
	
	if bodies.is_empty():
		state.target_body = null
	else:
		bodies.sort_custom(_sort_bodies_by_distance)
		state.target_body = bodies.front()
	
	animations.rotate_turret(state.target_body)
	_rotate_muzzle_marker(state.target_body)


func _sort_bodies_by_distance(a: PhysicsBody2D, b: PhysicsBody2D) -> bool:
	var a_distance := entity.global_position.distance_to(a.global_position)
	var b_distance := entity.global_position.distance_to(b.global_position)
	return a_distance < b_distance


func _rotate_muzzle_marker(target_node: Node2D) -> void:
	if not is_instance_valid(target_node):
		_muzzle_rotator.rotation = 0.0
		return
	
	var target_angle = entity.global_position \
		.angle_to_point(target_node.global_position)
	
	_muzzle_rotator.global_rotation = target_angle + Math.HALF_PI


func _transition_attempts() -> void:
	match state.action:
		&'Move':
			var not_reloading = _reload_timer.is_stopped()
			if not_reloading and Inputs.attack.just_pressed:
				state.action = &'Attack'


func _begin() -> void:
	_reload_timer.start()
	_spawn_projectile()
	state.action = state.last_action


func _spawn_projectile() -> void:
	var projectile := bullet_projectile.instantiate() as Projectile
	projectile.damage = properties.damage
	projectile.collision_layer = bullet_collision_layer
	projectile.collision_mask = bullet_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	get_viewport().add_child(projectile)


func _is_action_active() -> bool:
	return state.action == &'Attack'
