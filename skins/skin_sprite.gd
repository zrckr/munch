class_name SkinSprite
extends Node2D

signal animation_finished(anim_name)

@export
var animation_speed := 1.0

@onready
var _animation_player: AnimationPlayer = $AnimationPlayer

@onready
var _sprite_2d: Sprite2D = $Sprite2D

@onready
var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

##
var animation_name: String:
	get: return _animation_player.current_animation

##
var animation_frame: int:
	get: return _sprite_2d.frame

##
var animation_position: float:
	get: return _animation_player.current_animation_position


func _ready() -> void:
	_animation_player.speed_scale = animation_speed


func serialize(state: EntityState) -> void:
	state.animation_name = animation_name
	state.animation_position = animation_position


func deserialize(state: EntityState) -> void:
	animation_name = state.animation_name
	animation_position = state.animation_position


func flip_sprite(horizontal := false, vertical := false) -> void:
	_sprite_2d.flip_h = horizontal
	_sprite_2d.flip_v = vertical


func modulate_sprite(color: Color) -> void:
	_sprite_2d.modulate = color


func set_idle() -> void:
	_sprite_2d.flip_h = false
	_animation_player.play('idle')


func set_move(direction: Vector2i) -> void:
	var facing_direction = ''
	_sprite_2d.flip_h = false
	
	if direction.x != 0:
		facing_direction = 'side'
	if direction.y < 0:
		facing_direction = 'up'
	if direction.y > 0:
		facing_direction = 'down'
	
	if facing_direction:
		_sprite_2d.flip_h = direction.x > 0
		_animation_player.play('move_' + facing_direction)


func reset_animation() -> void:
	if _animation_player.is_playing():
		_animation_player.play('RESET')
		_animation_player.advance(0)
		_animation_player.stop()


func _on_animation_player_finished(anim_name: String) -> void:
	animation_finished.emit(anim_name)
