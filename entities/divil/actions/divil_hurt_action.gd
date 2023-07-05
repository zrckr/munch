extends EntityAction

@onready
var _hurtbox: CollisionBox = $HurtBox

@onready
var _invincibility_timer: Timer = $InvincibilityTimer

@onready
var _stun_timer: Timer = $StunTimer


func _on_hurtbox_area_entered(damage_source: Area2D) -> void:
	var excluded_actions = [&'Defeat', &'Rtd']
	if state.action in excluded_actions:
		return
	
	var is_projectile = damage_source is Projectile
	var is_collision_box = damage_source is CollisionBox
	
	if not (is_projectile or is_collision_box):
		return
	
	state.damage_position = damage_source.global_position
	if is_projectile:
		state.damage_value = damage_source.damage
		damage_source.queue_free()
	elif is_collision_box:
		state.damage_value = damage_source.properties.damage
	
	state.action = &'Hurt'


func _begin() -> void:
	_hurtbox.disable()
	animations.damaged()
	state.take_damage(state.damage_value)
	
	var strength = properties.speed * state.damage_value
	var direction = state.damage_position \
		.direction_to(entity.global_position) \
		.round()
	
	state.knockback_velocity = direction * strength
	_stun_timer.start()


func _act(_delta) -> void:
	if not _stun_timer.is_stopped():
		entity.velocity = state.knockback_velocity
		entity.move_and_slide()


func _on_stun_timer_timeout() -> void:
	if state.health_points <= 0:
		state.action = &'Defeat'
		return
	
	_invincibility_timer.start()
	animations.blink(_invincibility_timer.wait_time)
	state.action = &'Move'


func _on_invincibility_timer_timeout() -> void:
	_hurtbox.enable()


func _is_action_active() -> bool:
	return state.action == &'Hurt'
