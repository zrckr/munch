class_name Spawner
extends Node2D

@export_range(1, 60, 1, 'suffix:seconds')
var time_to_spawn: int

@export
var shader_material: ShaderMaterial

@onready
var _timer: Timer = $Timer

var entity_scene: PackedScene:
	set(value): entity_scene = value

var entity_groups: Array:
	set(value): entity_groups = value

var _entity_to_spawn: Node2D


func _ready() -> void:
	_timer.start(time_to_spawn)
	call_deferred('_prepare_entity_to_spawn')


func _process(_delta: float) -> void:
	var elapsed = (time_to_spawn - _timer.time_left)
	var total = (elapsed / time_to_spawn)
	
	if _entity_to_spawn and _entity_to_spawn.material:
		_entity_to_spawn.material.set_shader_parameter('amount', total)


func _prepare_entity_to_spawn() -> void:
	_entity_to_spawn = entity_scene.instantiate()
	
	_entity_to_spawn.global_position = global_position
	_entity_to_spawn.process_mode = Node.PROCESS_MODE_DISABLED
	_entity_to_spawn.material = shader_material.duplicate()
	
	get_tree().current_scene.add_child(_entity_to_spawn)
	for group in entity_groups:
		_entity_to_spawn.add_to_group(group)


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Entity:
		set_physics_process(false)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is Entity:
		set_physics_process(true)


func _on_timer_timeout() -> void:
	_entity_to_spawn.material = null
	_entity_to_spawn.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
