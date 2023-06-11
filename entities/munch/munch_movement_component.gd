extends MovementComponent

## %
const MIN_ANGLE := -5

## %
const MAX_ANGLE := 5

@onready
var _scatter_timer: Timer = $ScatterTimer

var _positioner: Positioner

var _target_position: Vector2

var _default_position: Vector2

var _chasing_entity: Entity

var _is_frightened: bool:
	get: return _chasing_entity != null


func _enter_tree() -> void:
	if not _positioner:
		# fallback instance
		_positioner = Positioner.new() \
			.set_min_position(Vector2.ZERO) \
			.set_max_position(get_viewport().size / 2.0)
	
	_default_position = _entity.global_position
	_target_position = _positioner.get_random_inside_box()


func _physics_process(_delta: float) -> void:
	if _is_frightened:
		_find_position_during_chase()
	else:
		_find_position_for_scatter()
	
	_normalize_target_position()
	_move_until_scatter()


func _find_position_for_scatter() -> void:
	var total_munches = len(get_tree().get_nodes_in_group(Entity.Group.MUNCH))
	_current_speed = _properties.speed / total_munches
	
	var distance = _entity.global_position.distance_to(_target_position)
	if distance <= 1.0:
		if _scatter_timer.is_stopped():
			_scatter_timer.start()


func _find_position_during_chase() -> void:
	var degrees = randi_range(MIN_ANGLE, MAX_ANGLE)
	var angle = PI + deg_to_rad(degrees)
	
	var direction = _entity.global_position.direction_to(_chasing_entity.global_position)
	var opposite = direction.rotated(angle)
	
	_target_position = _entity.global_position + opposite
	_current_speed = _properties.speed


func _normalize_target_position() -> void:
	if not _positioner.is_inside_bounds(_target_position):
		_target_position = _positioner \
			.set_edge_offset(Math.QUADRUPLE) \
			.get_clamped(_target_position)


func _move_until_scatter() -> void:
	if _scatter_timer.is_stopped():
		_entity.velocity = _entity.global_position.direction_to(_target_position)
		_entity.velocity *= _current_speed
		_entity.move_and_slide()


func _on_scatter_timer_timeout() -> void:
	var offset = Random.randv_range(-Math.SEXTUPLE, Math.SEXTUPLE)
	_target_position = _positioner \
		.set_edge_offset(Math.QUADRUPLE) \
		.get_clamped(_entity.global_position + offset)


func _on_detection_component_body_entered(entity: Entity) -> void:
	if not _chasing_entity:
		_chasing_entity = entity


func _on_lost_component_body_exited(entity: Entity) -> void:
	if _chasing_entity == entity:
		_chasing_entity = null
