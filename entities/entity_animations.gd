@icon('res://editor/icons/animation.png')
class_name EntityAnimations
extends Node2D

signal started(name)

signal finished(name)

@onready
var entity := owner as Entity:
	get: return entity

@onready
var _sprite: Sprite2D = $Sprite

@onready
var _animation_player: AnimationPlayer = $Player


func reset() -> void:
	_animation_player.play('RESET')


func blink(time_sec: float) -> void:
	var delta := get_process_delta_time()
	var frames := 0
	
	while frames < int(time_sec / delta):
		await get_tree().process_frame
		frames += 1
		visible = frames % 3 == 2
	
	visible = true


func _play_directional_animation(anim_name: String, direction: Vector2i) -> void:
	var facing_direction = (
		'_side' if direction.x != 0
		else '_up' if direction.y < 0
		else '_down' if direction.y > 0
		else ''
	)
	
	if facing_direction:
		_sprite.flip_h = direction.x != 0 and direction.x > 0
		_animation_player.play(anim_name + facing_direction)


func _on_animation_player_started(anim_name: StringName) -> void:
	started.emit(anim_name)


func _on_animation_player_finished(anim_name: StringName) -> void:
	finished.emit(anim_name)
