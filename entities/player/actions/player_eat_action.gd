extends EntityAction

@onready
var _munchbox: CollisionBox = $MunchBox


func _on_munchbox_area_entered(munch_hitbox: CollisionBox) -> void:
	if state.action != &'Move' or state.action == &'Eat':
		return
	
	munch_hitbox.disable()
	munch_hitbox.entity.queue_free()
	
	state.munchies_eaten += 1
	state.action = &'Eat'


func _begin() -> void:
	_munchbox.disable()
	if state.munchies_eaten >= state.munchies_total:
		animations.begin_transform()
	else:
		animations.move(state.facing_direction, 2.0)
		await get_tree().create_timer(0.25, false, false).timeout
		state.action = &'Idle'


func _end() -> void:
	_munchbox.enable()


func _on_animations_finished(anim_name: String) -> void:
	if 'begin_transform' in anim_name:
		entity.roll_the_dice()


func _is_action_active() -> bool:
	return state.action == &'Eat'
