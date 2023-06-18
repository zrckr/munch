extends Camera2D

@export
var follow_player: bool

@export_group('Shake', 'shake_')

@export
var shake_disabled: bool

@export_range(1, 10, 1, 'suffix:px')
var shake_damage_intensity: float

@export_range(0, 1, 0.01, 'suffix:seconds')
var shake_damage_duration: float


var player_entity: Entity:
	get: return get_tree().get_first_node_in_group(Entity.Group.PLAYER)


func _ready() -> void:
	Events.player_damaged.connect(_on_player_damaged)


func _physics_process(_delta: float) -> void:
	if player_entity and follow_player:
		global_position = player_entity.global_position


func shake(intensity: float, duration: float) -> void:
	if shake_disabled:
		push_warning('The camera shake was disabled')
		return
	
	var elapsed := 0.0
	offset = Vector2.ZERO
	
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		offset = Random.randv_unit() * intensity
	
	elapsed = duration
	offset = Vector2.ZERO


func _on_player_damaged() -> void:
	shake(shake_damage_intensity, shake_damage_duration)
