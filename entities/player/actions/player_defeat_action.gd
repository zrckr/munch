extends EntityAction


func _begin() -> void:
	Events.player_died.emit()
	animations.defeated()


func _on_animations_finished(anim_name: String) -> void:
	if 'defeated' in anim_name:
		entity.queue_free()


func _is_action_active() -> bool:
	return state.action == &'Defeat'
