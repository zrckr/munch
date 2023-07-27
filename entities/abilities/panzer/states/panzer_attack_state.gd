extends State

@export var bullet_projectile: PackedScene
@export_flags_2d_physics var bullet_collision_layer: int
@export_flags_2d_physics var bullet_collision_mask: int

@export_group('State Dependencies')
@export var turret_sprite: Sprite2D
@export var muzzle_marker: Marker2D
@export var reload_timer: Timer
@export var attack_box: CollisionBox

@export_group('Panzer Dependencies')
@export var panzer: Entity
@export var panzer_animations: EntityAnimations
@export var panzer_blackboard: PanzerBlackboard


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_find_nearest_target_body()


func _find_nearest_target_body() -> void:
	var bodies = attack_box.get_overlapping_bodies().duplicate()
	
	if bodies.is_empty():
		panzer_blackboard.target_body = null
	else:
		bodies.sort_custom(sort_bodies_by_distance)
		panzer_blackboard.target_body = bodies.front()
	
	rotate_node(turret_sprite, panzer_blackboard.target_body)


func sort_bodies_by_distance(a: PhysicsBody2D, b: PhysicsBody2D) -> bool:
	var a_distance := panzer.global_position.distance_to(a.global_position)
	var b_distance := panzer.global_position.distance_to(b.global_position)
	return a_distance < b_distance


func rotate_node(source_node: Node2D, target_node: Node2D) -> void:
	if not is_instance_valid(target_node):
		source_node.rotation = 0.0
		return
	
	var target_angle = panzer.global_position.angle_to_point(target_node.global_position)
	source_node.global_rotation = target_angle + Math.HALF_PI


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Move':
			var not_reloading = reload_timer.is_stopped()
			if not_reloading and Inputs.attack.just_pressed:
				state_machine.transition_queue(&'Attack')


func begin(_kwargs := {}) -> void:
	reload_timer.start()
	spawn_projectile()
	state_machine.transition_back()


func spawn_projectile() -> void:
	var projectile := bullet_projectile.instantiate() as Projectile
	projectile.damage = panzer.properties.damage
	projectile.collision_layer = bullet_collision_layer
	projectile.collision_mask = bullet_collision_mask
	projectile.transform = muzzle_marker.global_transform
	get_viewport().add_child(projectile)
