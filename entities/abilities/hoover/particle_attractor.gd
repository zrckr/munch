@icon('res://editor/icons/node.png')
class_name ParticleAttractor
extends Node2D

@export
var min_spawn_position: Vector2i

@export
var max_spawn_position: Vector2i

@export_range(0.01, 1.0, 0.01, 'suffix:seconds')
var spawn_max_delay: float

@export_range(0.01, 1.0, 0.01, 'suffix:seconds')
var attraction_time: float

var _particles := []

var _emitting := false


func _ready() -> void:
	for node in get_children():
		node.visible = false
		_particles.append({
			sprite = node,
			tween = null,
			timer = null
		})


func start_emitting() -> void:
	_emitting = true
	for particle in _particles:
		_spawn_particle(particle)


func stop_emitting() -> void:
	_emitting = false
	for particle in _particles:
		_despawn_particle(particle)


func _spawn_particle(particle: Dictionary) -> void:
	var wait_time = randf_range(0, spawn_max_delay)
	particle.timer = get_tree().create_timer(wait_time, false, false)
	particle.timer.timeout.connect(_animate_particle.bind(particle))
	particle.sprite.visible = false


func _animate_particle(particle: Dictionary) -> void:
	if not _emitting:
		return
	
	if particle.tween:
		particle.tween.kill()
	
	particle.tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_IDLE) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	particle.sprite.visible = true
	particle.sprite.position = Random.randv_axes(min_spawn_position, max_spawn_position)
	
	particle.tween.tween_property(particle.sprite, 'position', Vector2.ZERO, attraction_time)
	particle.tween.finished.connect(_on_particle_tween_finished.bind(particle))


func _despawn_particle(particle: Dictionary) -> void:
	particle.timer = null
	particle.sprite.visible = false
	if particle.tween:
		particle.tween.kill()


func _on_particle_tween_finished(particle: Dictionary) -> void:
	particle.timer = null
	particle.sprite.visible = false
	if _emitting:
		_spawn_particle(particle)
