class_name AnimationComponent
extends Node2D

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

@onready
var _sprite: Sprite2D = $Sprite

@onready
var _player: AnimationPlayer = $Player


func _serialize(state: EntityState) -> void:
	if _player:
		state.animation_name = _player.current_animation
		state.animation_position = _player.current_animation_position


func _deserialize(state: EntityState) -> void:
	if _player:
		_player.stop()
		_player.play(state.animation_name)
		_player.advance(state.animation_position)


func flip_sprite_h(value: bool) -> void:
	_sprite.flip_h = value


func blink_sprite(time_sec: float) -> void:
	var delta := get_physics_process_delta_time()
	var frames := 0
	
	while frames < int(time_sec / delta):
		await get_tree().physics_frame
		frames += 1
		visible = frames % 3 == 2
	
	visible = true


func play_default() -> void:
	_player.play('default')


func play_idle() -> void:
	_sprite.flip_h = false
	_player.play('idle')


func play_rolling_vertical(speed_scale: float) -> void:
	if _player.current_animation != 'rolling_vertical':
		_player.play('rolling_vertical')
	_player.speed_scale = clampf(speed_scale, -2.0, 2.0)


func play_move(direction: Vector2i) -> void:
	var facing_direction = _determine_facing_direction(direction)
	_sprite.flip_h = false
	
	if facing_direction:
		_sprite.flip_h = direction.x > 0
		_player.play('move' + facing_direction)


func play_damaged() -> void:
	_sprite.modulate = Color.RED
	if _player.has_animation('damaged'):
		_player.play('damaged')


func play_defeated_async(direction := Vector2i.ZERO) -> void:
	var facing_direction = _determine_facing_direction(direction)

	if _player.has_animation('defeated' + facing_direction):
		_player.play('defeated' + facing_direction)
	else:
		_player.play('defeated')
	
	await _player.animation_finished


func reset_sprite_modulation() -> void:
	_sprite.modulate = Color.WHITE


func reset() -> void:
	if _player.is_playing():
		_player.play('RESET')
		_player.advance(0)
		_player.stop()


func _determine_facing_direction(direction := Vector2i.ZERO) -> String:
	if direction.x != 0:
		return '_side'
	if direction.y < 0:
		return '_up'
	if direction.y > 0:
		return '_down'
	return ''
