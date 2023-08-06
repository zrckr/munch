extends State

@export
var health_component: HealthComponent

@export
var velocity_component: VelocityComponent

@export_group('State Dependencies')
@export var hurtbox: CollisionBox
@export var invincibility_timer: Timer
@export var stun_timer: Timer

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations

var knockback_velocity: Vector2


func _ready() -> void:
	await player.ready


func _on_hurtbox_area_entered(damage_source: Area2D) -> void:
	var excluded_actions = [&'Defeat', &'Rtd']
	if state_machine.current_state.name in excluded_actions:
		return
	
	var is_projectile = damage_source is Projectile
	var is_collision_box = damage_source is CollisionBox
	
	if not (is_projectile or is_collision_box):
		return
	
	var kwargs = {}
	kwargs.damage_position = damage_source.global_position
	
	if is_projectile:
		kwargs.damage_value = damage_source.damage
		damage_source.queue_free()
	elif is_collision_box:
		kwargs.damage_value = damage_source.properties.damage
	
	state_machine.transition_to(&'Hurt', kwargs)


func begin(kwargs := {}) -> void:
	hurtbox.disable()
	player_animations.play('damaged')
	
	health_component.damage(kwargs.damage_value)
	
	var strength = player.properties.speed * kwargs.damage_value
	var direction = kwargs.damage_position \
		.direction_to(player.global_position) \
		.round()
	
	knockback_velocity = direction * strength
	stun_timer.start()


func act(_delta: float) -> void:
	if not stun_timer.is_stopped():
		velocity_component.move(knockback_velocity)


func _on_stun_timer_timeout() -> void:
	if health_component.is_dead:
		state_machine.transition_to(&'Defeat')
		return
	
	invincibility_timer.start()
	player_animations.blink(invincibility_timer.wait_time)
	state_machine.transition_to(&'Idle')


func _on_invincibility_timer_timeout() -> void:
	hurtbox.enable()
