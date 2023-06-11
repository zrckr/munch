extends MovementComponent

var _target_to_chase: Entity


func _ready() -> void:
	Events.player_died.connect(_on_player_died)


func _physics_process(_delta: float) -> void:
	_target_to_chase = get_tree() \
		.get_first_node_in_group(Entity.Group.PLAYER) \
		as Entity
	
	if not _target_to_chase:
		_entity.animation_component.play_idle()
		return
	
	_current_direction = _entity.global_position \
		.direction_to(_target_to_chase.global_position)
	
	_entity.velocity = _current_direction * _current_speed
	_entity.move_and_slide()
	
	if not _current_direction.is_zero_approx():
		if _entity.animation_component:
			_entity.animation_component.play_move(facing_direction)


func _on_detection_component_body_entered(entity: Entity) -> void:
	if not _target_to_chase:
		_target_to_chase = entity


func _on_player_died() -> void:
	_entity.animation_component.play_idle()
	set_physics_process(false)
