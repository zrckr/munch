class_name HooverSuctionComponent
extends Area2D

@export
var particle_emitter: HooverParticleEmitter

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

var _suction_amount: int = 0

var _suction_tween: Tween = null

@onready
var _collision_polygon: CollisionPolygon2D = $CollisionPolygon

@onready
var _capacity_label: Label = $CapacityLabel

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed('use'):
		_begin_suction_action()
		return
	
	if Input.is_action_just_released('use'):
		_end_suction_action()
		return


func _begin_suction_action() -> void:
	_entity.movement_component.disable()


func _on_body_entered_during_suction(entity: Entity) -> void:
	entity.process_mode = Node.PROCESS_MODE_DISABLED
	entity.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	_suction_tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	_suction_tween.tween_property(entity, 'position', global_position, suction_time)
	_suction_tween.finished.connect(_on_suction_tween_finished.bind(entity))


func _on_suction_tween_finished(entity: Entity) -> void:
	if is_instance_valid(entity):
		_suction_amount += 1
		entity.queue_free()
	
	if _suction_amount >= suction_capacity:
		_collision_polygon.set_deferred('disabled', true)


func _end_suction_action() -> void:
	_entity.movement_component.enable()
