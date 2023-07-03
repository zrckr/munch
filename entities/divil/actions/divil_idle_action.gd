extends EntityAction


func _ready() -> void:
	Events.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	state.action = &'Idle'


func _begin() -> void:
	animations.idle()


func _is_action_active() -> bool:
	return state.action == &'Idle'
