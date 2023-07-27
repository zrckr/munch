extends State

@export_group('State Dependencies')
@export var shield: Node2D
@export var shield_box: CollisionBox
@export var duration_timer: Timer
@export var wait_timer: Timer

@export_group('Panzer Dependencies')
@export var panzer: Entity
@export var panzer_animations: EntityAnimations
@export var panzer_blackboard: PanzerBlackboard


func _ready() -> void:
	await panzer.ready
	
	duration_timer.timeout.connect(on_duration_timer_timeout)
	wait_timer.timeout.connect(on_wait_timer_timeout)
	shield_box.area_entered.connect(on_shield_box_area_entered)
	
	on_duration_timer_timeout()


func transition_attempts() -> void:
	if panzer_blackboard.shield_active:
		return

	match state_machine.current_state.name:
		&'Move', &'Attack':
			var wait_stopped = wait_timer.is_stopped()
			if wait_stopped and Inputs.use.just_pressed:
				panzer_blackboard.shield_active = true


func begin(_kwargs := {}) -> void:
	print('PANZER: Shield was deployed!')
	duration_timer.start()
	shield_box.enable()
	shield.visible = true


func on_duration_timer_timeout() -> void:
	print('PANZER: Shield is recharging...')
	panzer_blackboard.shield_active = false
	wait_timer.start()
	shield_box.disable()
	shield.visible = false


func on_wait_timer_timeout() -> void:
	print('PANZER: Shield is ready!')


func is_state_active(_current_state: State) -> bool:
	return panzer_blackboard.shield_active


func on_shield_box_area_entered(area: Area2D) -> void:
	if area.owner is Projectile:
		area.owner.queue_free()
