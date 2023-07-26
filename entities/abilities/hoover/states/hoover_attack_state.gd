extends State

@export var projectile_scene: PackedScene
@export_flags_2d_physics var projectile_collision_layer: int
@export_flags_2d_physics var projectile_collision_mask: int
@export var muzzle_marker: Marker2D
@export var attack_timer: Timer

@export_group('Hoover Dependencies')
@export var hoover: Entity
@export var hoover_animations: EntityAnimations
@export var hoover_blackboard: HooverBlackboard


func _ready() -> void:
	attack_timer.timeout.connect(on_attack_timer_timeout)


func _process(_delta: float) -> void:
	muzzle_marker.rotation = hoover_blackboard.get_suction_angle() + PI


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Idle', &'Move':
			if hoover_blackboard.can_shoot and Inputs.attack.just_pressed:
				state_machine.transition_to(&'Attack')


func begin(_kwargs := {}) -> void:
	hoover_blackboard.suction_amount = 0
	hoover_animations.direction = hoover_blackboard.facing_direction
	hoover_animations.play('hoover/suck')
	
	spawn_projectile()
	attack_timer.start()


func spawn_projectile() -> void:
	var projectile := projectile_scene.instantiate() as Projectile
	projectile.damage = hoover.properties.damage
	projectile.collision_layer = projectile_collision_layer
	projectile.collision_mask = projectile_collision_mask
	projectile.transform = muzzle_marker.global_transform
	get_viewport().add_child(projectile)


func on_attack_timer_timeout() -> void:
	hoover_animations.play('hoover/RESET')
	state_machine.transition_to(&'Idle')
