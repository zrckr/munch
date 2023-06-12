extends Node2D

enum State {
	RELOADING,
	READY,
}

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

@export
var bullet_projectile: PackedScene

var _state: State:
	get:
		return _state
	set(value):
		_state = value
		_process_attack(value)

@export_flags_2d_physics
var bullet_collision_layer: int

@export_flags_2d_physics
var bullet_collision_mask: int

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker

@onready
var _reload_timer: Timer = $ReloadTimer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		call_deferred('_spawn_projectile_instance')
		_state = State.RELOADING


func _process_attack(new_state: State) -> void:
	match new_state:
		State.READY:
			set_process_unhandled_input(true)
		
		State.RELOADING:
			set_process_unhandled_input(false)
			_reload_timer.start()


func _spawn_projectile_instance() -> void:
	var projectile = bullet_projectile.instantiate() as Projectile
	
	projectile.collision_layer = bullet_collision_layer
	projectile.collision_mask = bullet_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	
	if get_tree().current_scene == _entity:
		get_tree().root.add_child(projectile)
	else:
		get_tree().current_scene.add_child(projectile)


func _on_reload_timer_timeout() -> void:
	_state = State.READY
