extends Node

enum State {
	RECHARGING,
	READY,
	DEPLOYED,
}

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var _state: State:
	get:
		return _state
	set(value):
		_state = value
		_process_shield(value)

@onready 
var _collision: CollisionPolygon2D = $Collision

@onready 
var _wait_timer: Timer = $WaitTimer

@onready 
var _duration_timer: Timer = $DurationTimer

@onready 
var _shield: Node2D = $Shield


func _ready() -> void:
	_state = State.RECHARGING


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('use'):
		print('[PANZER] Shield was deployed!')
		_state = State.DEPLOYED


func _process_shield(new_state: State) -> void:
	match new_state:
		State.RECHARGING:
			set_process_unhandled_input(false)
			_shield.set_deferred('visible', false)
			_collision.set_deferred('disabled', true)
			_wait_timer.start()
		
		State.READY:
			set_process_unhandled_input(true)
		
		State.DEPLOYED:
			set_process_unhandled_input(false)
			_shield.set_deferred('visible', true)
			_collision.set_deferred('disabled', false)
			_duration_timer.start()


func _on_wait_timer_timeout() -> void:
	print('[PANZER] Shield is ready!')
	_state = State.READY


func _on_duration_timer_timeout() -> void:
	print('[PANZER] Shield is recharging...')
	_state = State.RECHARGING


func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		area.queue_free()
