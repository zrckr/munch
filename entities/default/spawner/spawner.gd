extends Node2D

@export_range(1, 60, 1, 'suffix:seconds')
var time_to_spawn: int

@export
var shader_material: ShaderMaterial

@onready
var sprite: Sprite2D = $Sprite

@onready
var timer: Timer = $Timer

##
var entity_scene: PackedScene:
	set(value): _entity_scene = value

##
var entity_groups: Array:
	set(value): _entity_groups = value

##
var _entity_scene: PackedScene

##
var _entity_groups: Array

##
var _entity_to_spawn: Node2D


func _ready() -> void:
	sprite.visible = false
	timer.start(time_to_spawn)
	_prepare_entity_to_spawn()


func _physics_process(_delta: float) -> void:
	var no_time = not timer or timer.is_stopped()
	var no_entity = not _entity_to_spawn
	if no_time or no_entity:
		return
	
	var elapsed = (time_to_spawn - timer.time_left)
	var total = (elapsed / time_to_spawn)
	
	if _entity_to_spawn and _entity_to_spawn.material:
		_entity_to_spawn.material.set_shader_parameter('amount', total)


func _prepare_entity_to_spawn() -> void:
	await get_tree().process_frame
	
	_entity_to_spawn = _entity_scene.instantiate()
	_entity_to_spawn.global_position = global_position
	_entity_to_spawn.process_mode = Node.PROCESS_MODE_DISABLED
	_entity_to_spawn.material = shader_material.duplicate()
	get_tree().root.add_child(_entity_to_spawn)
	
	var skin = _entity_to_spawn.get_node('./Skin')
	if skin is SkinSprite:
		skin.reset_animation()
	
	for group in _entity_groups:
		_entity_to_spawn.add_to_group(group)


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.collision_layer & Physics.Layer.PLAYER:
		set_physics_process(false)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.collision_layer & Physics.Layer.PLAYER:
		set_physics_process(true)


func _on_timer_timeout() -> void:
	_entity_to_spawn.material = null
	_entity_to_spawn.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
