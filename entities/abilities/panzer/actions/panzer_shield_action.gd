extends EntityAction

@onready
var _duration_timer: Timer = $DurationTimer

@onready
var _wait_timer: Timer = $WaitTimer

@onready
var _shield_box: CollisionBox = $ShieldBox


func _ready() -> void:
	await entity.ready
	_on_duration_timer_timeout()


func _transition_attempts() -> void:
	if state.shield_active:
		return

	match state.action:
		&'Move', &'Attack':
			var use_pressed = Input.is_action_just_pressed('use')
			var wait_stopped = _wait_timer.is_stopped()
			if use_pressed and wait_stopped:
				state.shield_active = true


func _begin() -> void:
	print('[PANZER] Shield was deployed!')
	_duration_timer.start()
	_shield_box.enable()
	animations.show_shield()


func _on_duration_timer_timeout() -> void:
	print('[PANZER] Shield is recharging...')
	state.shield_active = false
	
	_wait_timer.start()
	_shield_box.disable()
	animations.hide_shield()


func _on_wait_timer_timeout() -> void:
	print('[PANZER] Shield is ready!')


func _is_action_active() -> bool:
	return state.shield_active


func _on_shield_box_area_entered(area: Area2D) -> void:
	if area.owner is Projectile:
		area.owner.queue_free()
