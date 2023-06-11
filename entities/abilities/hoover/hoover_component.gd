extends Node2D

## seconds
const SUCTION_TIME := 0.5

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

@onready
var _animation_player: AnimationPlayer = $AnimationPlayer

@onready
var _pivot: Node2D = $Pivot

##
var _suction_tween: Tween


func _physics_process(_delta: float) -> void:
	var direction := _entity.movement_component.facing_direction
	if direction == Vector2i.ZERO:
		direction = Vector2i.DOWN
	
	var just_pressed = Input.is_action_just_pressed('attack')
	var pressed = Input.is_action_pressed('attack')
	
	if just_pressed or pressed:
		_entity.movement_component.disable()
		_play_suck_animation(direction)
		return
	
	if Input.is_action_just_released('attack'):
		_entity.movement_component.enable()
		_reset_animation()
		return


func _play_suck_animation(direction: Vector2i) -> void:
	var facing_direction = ''
	if direction.x != 0:
		facing_direction = 'side'
	if direction.y < 0:
		facing_direction = 'up'
	if direction.y > 0:
		facing_direction = 'down'
	
	if facing_direction:
		_entity.animation_component.reset()
		_flip_particles(direction.x != 0 and direction.x > 0)
		_animation_player.play('suck_' + facing_direction)


func _reset_animation() -> void:
	_flip_particles(false)
	_stop_animation()
	_entity.animation_component.play_idle()


func _on_suction_area_body_entered(entity: Entity) -> void:
	entity.process_mode = Node.PROCESS_MODE_DISABLED
	entity.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	_suction_tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	_suction_tween.tween_property(entity, 'position', global_position, SUCTION_TIME)
	_suction_tween.tween_property(entity, 'scale', Vector2.ZERO, SUCTION_TIME)
	
	await _suction_tween.finished
	
	if entity != null:
		entity.queue_free()


func _flip_particles(value: bool) -> void:
	_entity.animation_component.flip_sprite_h(value)
	_pivot.scale.y = -1 if value else 1


func _stop_animation() -> void:
	if _animation_player.is_playing():
		_animation_player.play('RESET')
		_animation_player.advance(0)
		_animation_player.stop()
