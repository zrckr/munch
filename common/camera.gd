extends Camera2D

@export
var follow_to_player := true

@export
var disable_shake := false

var player_entity: Entity:
	get: return get_tree().get_first_node_in_group(Entity.Group.PLAYER)


func _physics_process(_delta: float) -> void:
	if player_entity and follow_to_player:
		global_position = player_entity.global_position


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
