class_name NoisePositioner
extends RefCounted

const MAX_INTERATIONS := 100

var _noise := FastNoiseLite.new()

var _random := RandomNumberGenerator.new()

var _map_size := Rect2()


func _init() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	_noise.frequency = 0.01
	_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	_noise.fractal_lacunarity = 2
	_noise.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN
	_noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE


func set_seed(value: int) -> NoisePositioner:
	_random.seed = value
	_noise.seed = _random.randi()
	return self
 

func set_state(value: int) -> NoisePositioner:
	_random.state = value
	_noise.seed = _random.randi()
	return self


func set_frequency(value: float) -> NoisePositioner:
	_noise.frequency = value
	return self


func set_gain(value: float) -> NoisePositioner:
	_noise.fractal_gain = value
	return self


func set_octaves(value: int) -> NoisePositioner:
	_noise.fractal_octaves = value
	return self


func set_jitter(value: float) -> NoisePositioner:
	_noise.cellular_jitter = value
	return self


func set_offset(value: Vector2) -> NoisePositioner:
	_noise.offset = Vector3(value.x, value.y, 0)
	return self


func set_map_size(value: Rect2) -> NoisePositioner:
	_map_size = value
	return self


func get_position(noise_threshold := 0.5) -> Vector2:
	for i in range(MAX_INTERATIONS):
		var position = Vector2(
			_random.randf_range(_map_size.position.x, _map_size.end.x),
			_random.randf_range(_map_size.position.y, _map_size.end.y))
		
		position = position.round()
		var noise_level = absf(_noise.get_noise_2d(position.x, position.y))
		
		if noise_level >= noise_threshold:
			return position
	
	return _map_size.get_center()
