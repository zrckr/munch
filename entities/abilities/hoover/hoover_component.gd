class_name HooverSuctionComponent
extends Area2D

@export
var projectile_scene: PackedScene

@export_flags_2d_physics
var projectile_collision_layer: int

@export_flags_2d_physics
var projectile_collision_mask: int

@export_range(0.1, 1, 0.1, 'suffix:seconds')
var suction_time: float

@export_range(1, 10, 1, 'suffix:entities')
var suction_capacity: int

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var _can_shoot_projectiles: bool:
	get: return _suction_amount >= suction_capacity

var _suction_amount: int:
	get: return _suction_amount
	set(value):
		_suction_amount = value
		_capacity_label.text = ('%01d' % value) if value > 0 else ''

var _suction_tweens := {}

@onready
var _collision_polygon: CollisionPolygon2D = $CollisionPolygon

@onready
var _particle_attractor: ParticleAttractor = $ParticleAttractor

@onready
var _capacity_label: Label = $CapacityLabel

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker

@onready
var _attack_timer: Timer = $AttackTimer


func _ready() -> void:
	_suction_amount = 0


func _physics_process(_delta: float) -> void:
	var rotation_angle = Math.anglevi(_get_suction_direction())
	_collision_polygon.rotation = rotation_angle
	_particle_attractor.rotation = rotation_angle
	_muzzle_marker.rotation = PI + rotation_angle


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('use'):
		_begin_suction_action()
		return
	
	if Input.is_action_just_released('use'):
		_end_suction_action()
		return
	
	if Input.is_action_just_pressed('attack'):
		_shoot_projectiles()
		return


func _begin_suction_action() -> void:
	if not _can_shoot_projectiles:
		var direction = _get_suction_direction()
		_entity.animation_component.play_suck_animation(direction)
		_collision_polygon.set_deferred('disabled', false)
		_particle_attractor.start_emitting()
		_entity.movement_component.disable()


func _on_body_entered_during_suction(entity: Entity) -> void:
	if _can_shoot_projectiles:
		return
	
	entity.process_mode = Node.PROCESS_MODE_DISABLED
	entity.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	var tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	tween.tween_property(entity, 'position', _muzzle_marker.global_position, suction_time)
	tween.tween_property(entity, 'scale', Vector2.ZERO, suction_time)
	_suction_tweens[entity] = tween
	_suction_amount += 1
	
	await tween.finished
	
	_suction_tweens.erase(entity)
	entity.queue_free()
	
	if _can_shoot_projectiles:
		_end_suction_action()
		_collision_polygon.set_deferred('disabled', true)


func _shoot_projectiles() -> void:
	if not _can_shoot_projectiles:
		return
	
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.damage = _properties.damage
	projectile.collision_layer = projectile_collision_layer
	projectile.collision_mask = projectile_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	
	if get_tree().current_scene == _entity:
		get_tree().root.add_child(projectile)
	else:
		get_tree().current_scene.add_child(projectile)
	
	_begin_suction_action()
	_attack_timer.start()
	
	await _attack_timer.timeout
	_end_suction_action()


func _end_suction_action() -> void:
	_entity.animation_component.stop_suck_animation()
	_collision_polygon.set_deferred('disabled', true)
	_particle_attractor.stop_emitting()
	_entity.movement_component.enable()


func _get_suction_direction() -> Vector2i:
	var direction = Vector2i.DOWN
	var facing_direction = _entity.movement_component.facing_direction
	
	if facing_direction.x > 0:
		direction = Vector2.RIGHT
	if facing_direction.x < 0:
		direction = Vector2.LEFT
	if facing_direction.y < 0:
		direction = Vector2.UP
	if facing_direction.y > 0:
		direction = Vector2.DOWN
	
	return direction
