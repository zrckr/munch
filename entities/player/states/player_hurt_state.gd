extends State

const INFINITE_HEALTH_POINTS := -1

@export var hurtbox: CollisionBox
@export var invincibility_timer: Timer
@export var stun_timer: Timer

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations

var health_points: int:
	get:
		return health_points
	set(value):
		health_points = value
		Events.player_health_updated.emit(value)

var knockback_velocity: Vector2


func _ready() -> void:
	await player.ready
	
	hurtbox.area_entered.connect(on_hurtbox_area_entered)
	invincibility_timer.timeout.connect(on_stun_timer_timeout)
	stun_timer.timeout.connect(on_invincibility_timer_timeout)
	
	health_points = player.properties.health_points


func on_hurtbox_area_entered(damage_source: Area2D) -> void:
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
	
	if health_points != INFINITE_HEALTH_POINTS:
		Events.player_damaged.emit()
		health_points -= kwargs.damage_value
	
	var strength = player.properties.speed * kwargs.damage_value
	var direction = kwargs.damage_position \
		.direction_to(player.global_position) \
		.round()
	
	knockback_velocity = direction * strength
	stun_timer.start()


func act(_delta: float) -> void:
	if not stun_timer.is_stopped():
		player.velocity = knockback_velocity
		player.move_and_slide()


func on_stun_timer_timeout() -> void:
	if health_points <= 0:
		state_machine.transition_to(&'Defeat')
		return
	
	invincibility_timer.start()
	player_animations.blink(invincibility_timer.wait_time)
	state_machine.transition_to(&'Move')


func on_invincibility_timer_timeout() -> void:
	hurtbox.enable()
