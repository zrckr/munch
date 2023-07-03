extends EntityAction

var _damage_source: Node

var _knockback_velocity: Vector2

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
	
	if is_projectile or is_collision_box:
		_damage_source = damage_source
		state.action = &'Hurt'


func _begin() -> void:
	if _damage_source is Projectile:
		_damage_source.queue_free()
	
	_hurtbox.disable()
	animations.damaged()
	state.take_damage(_damage_source.damage)
	
	var strength = properties.speed * _damage_source.damage
	var direction = _damage_source.global_position \
		.direction_to(entity.global_position) \
		.round()
	
	_knockback_velocity = direction * strength
	_stun_timer.start()


func _act(_delta) -> void:
	if not _stun_timer.is_stopped():
		entity.velocity = _knockback_velocity
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
