extends EntityAction


func _begin() -> void:
	Events.enemy_died.emit(entity)
	animations.defeated()


func _on_animations_finished(anim_name: String) -> void:
	if 'defeated' in anim_name:
		entity.queue_free()


func _is_action_active() -> bool:
	return state.action == &'Defeat'
