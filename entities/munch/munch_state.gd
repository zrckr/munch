extends EntityState

# @injectable
var random_positioner: RandomPositioner

# @injectable
var noise_positioner: NoisePositioner

var facing_direction := Vector2.RIGHT

var target_position := Vector2.ZERO

var chasing_entities: Array[Entity] = []


func _ready() -> void:
	_init_positioners_with_fallbacks()
	action = &'Scatter'


func _process(_delta: float) -> void:
	if get_tree().debug_collisions_hint:
		queue_redraw()


func _draw() -> void:
	if get_tree().debug_collisions_hint:
		draw_set_transform_matrix(entity.global_transform.affine_inverse())
		draw_line(entity.global_position, target_position, Color.RED)


func generate_random_target_position():
	target_position = random_positioner.get_position_on_map()


func _init_positioners_with_fallbacks() -> void:
	var map_size = Rect2(Vector2.ZERO, get_viewport().size / 2.0)
	
	if not random_positioner:
		random_positioner = RandomPositioner.new() \
			.set_map_size(map_size) \
			.set_edge_offset(Math.DOUBLE) \
			.set_seed(0)
	
	if not noise_positioner:
		noise_positioner = NoisePositioner.new() \
			.set_map_size(map_size) \
			.set_seed(0) \
			.set_gain(20) \
			.set_octaves(2) \
			.set_jitter(0.45)
