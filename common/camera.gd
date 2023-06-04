extends Camera2D

@export
var follow_to_player := true

@export
var disable_shake := false


func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group(Game.Groups.PLAYER)
	if player is Node2D and follow_to_player:
		global_position = player.global_position


func shake(intensity: float, duration: float) -> void:
	if disable_shake:
		push_warning('The camera shake was disabled')
		return
	
	var elapsed := 0.0
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		offset = Random.randv_unit() * intensity
	
	print('DONE!')
