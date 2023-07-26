extends State

const MUNCHIES_TOTAL_FALLBACK := 100

@export var munchbox: CollisionBox

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations

var munchies_eaten: int:
	get:
		return munchies_eaten
	set(value):
		munchies_eaten = value
		Events.player_munchies_eaten.emit(value, munchies_total)

var munchies_total: int


func _ready() -> void:
	player_animations.finished.connect(on_player_animations_finished)
	munchbox.area_entered.connect(on_munchbox_area_entered)

	if not munchies_total:
		munchies_total = MUNCHIES_TOTAL_FALLBACK


func on_munchbox_area_entered(munch_hitbox: CollisionBox) -> void:
	match state_machine.current_state.name:
		&'Move':
			munch_hitbox.disable()
			munch_hitbox.entity.queue_free()
			munchies_eaten += 1
			state_machine.transition_to(&'Eat')


func begin(_kwargs := {}) -> void:
	munchbox.disable()
	if munchies_eaten >= munchies_total:
		player_animations.play('transform')
		return
	
	player_animations.play('move', 2.0)
	
	await get_tree().create_timer(0.25, false, false).timeout
	state_machine.transition_to(&'Idle')


func end() -> void:
	munchbox.enable()


func on_player_animations_finished(anim_name: String) -> void:
	if 'transform' in anim_name:
		player.roll_the_dice()
