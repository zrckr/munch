extends EntityAction

@export
var projectile_scene: PackedScene

@export_flags_2d_physics
var projectile_collision_layer: int

@export_flags_2d_physics
var projectile_collision_mask: int

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker

@onready
var _attack_timer: Timer = $AttackTimer


func _process(_delta: float) -> void:
	_muzzle_marker.rotation = state.get_suction_angle() + PI


func _transition_attempts() -> void:
	match state.action:
		&'Idle', &'Move':
			var can_shoot = state.suction_amount > 0
			if can_shoot and Inputs.attack.just_pressed:
				state.action = &'Attack'


func _begin() -> void:
	state.suction_amount = 0
	animations.suck(state.facing_direction)
	_spawn_projectile()
	_attack_timer.start()


func _spawn_projectile() -> void:
	var projectile := projectile_scene.instantiate() as Projectile
	projectile.damage = properties.damage
	projectile.collision_layer = projectile_collision_layer
	projectile.collision_mask = projectile_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	get_viewport().add_child(projectile)


func _on_attack_timer_timeout() -> void:
	animations.reset()
	state.action = &'Idle'


func _is_action_active() -> bool:
	return state.action == &'Attack'
