@icon('res://editor/icons/animation.png')
class_name EntityAnimations
extends Node2D

signal started(name)

signal finished(name)

var direction := Vector2.DOWN:
	get: return direction
	set(value): direction = value.normalized().round()

var directional_suffix: String:
	get: return (
		'_side' if not is_zero_approx(direction.x)
		else '_up' if direction.y < 0
		else '_down' if direction.y > 0
		else ''
	)

var is_opposite_side: bool:
	get: return not is_zero_approx(direction.x) and direction.x > 0

@onready
var _sprite: Sprite2D = $Sprite

@onready
var _animation_player: AnimationPlayer = $AnimationPlayer


func play(anim_name: StringName, custom_speed := 1.0) -> void:
	var anim_suffixed = '%s%s' % [anim_name, directional_suffix]
	
	if _animation_player.has_animation(anim_suffixed):
		_sprite.flip_h = is_opposite_side
		_animation_player.play(anim_suffixed, -1, custom_speed)
	else:
		_sprite.flip_h = false
		_animation_player.play(anim_name, -1, custom_speed)


func reset() -> void:
	_sprite.flip_h = false
	_animation_player.play(&'RESET')


func blink(time_sec: float) -> void:
	var delta := get_process_delta_time()
	var frames := 0
	
	while frames < int(time_sec / delta):
		await get_tree().process_frame
		frames += 1
		visible = frames % 3 == 2
	
	visible = true


func modulate_lerp(alpha: float, weight: float) -> void:
	_sprite.modulate.a = lerpf(_sprite.modulate.a, alpha, weight)


func look_at_lerp(point: Vector2, weight: float) -> void:
	var angle_offset = (to_local(point) * scale).angle()
	angle_offset += PI / 2.0
	rotation = lerp_angle(rotation, rotation + angle_offset, weight)


func _on_animation_player_started(anim_name: StringName) -> void:
	started.emit(anim_name)


func _on_animation_player_finished(anim_name: StringName) -> void:
	finished.emit(anim_name)
