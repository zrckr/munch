extends State

@export
var munch_component: MunchComponent

@export_group('State Dependencies')
@export var munchbox: CollisionBox

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func _on_munchbox_area_entered(munch_hitbox: CollisionBox) -> void:
	match state_machine.current_state.name:
		&'Move':
			munch_component.eat_munch(munch_hitbox)
			state_machine.transition_to(&'Eat')


func begin(_kwargs := {}) -> void:
	munchbox.disable()
	
	if munch_component.can_transform_to_ability:
		player_animations.play('transform')
		return
	
	player_animations.play('move', 2.0)
	
	await get_tree().create_timer(0.25, false, false).timeout
	state_machine.transition_to(&'Idle')


func end() -> void:
	munchbox.enable()


func _on_player_animations_finished(anim_name: String) -> void:
	if 'transform' in anim_name:
		player.roll_the_dice()
