extends Control

const MARGIN := 8

@onready
var camera: Camera2D = get_viewport().get_camera_2d()

@onready
var parent: Node2D = get_parent()

@onready
var marker: TextureRect = $Marker

@export
var sticky_to_viewport_egdes := true


func _ready() -> void:
	if not parent is Node2D:
		push_error("The waypoint's parent node must inherit from Node2D")


func _process(_delta: float) -> void:
	if not camera.enabled:
		camera = get_viewport().get_camera_2d()
		
	var parent_position = parent.global_position
	var camera_position = camera.get_screen_center_position()
	
	var distance = camera_position.distance_to(parent_position)
	modulate.a = clamp(remap(distance, 0, 2, 0, 1), 0, 1)
	
	if not sticky_to_viewport_egdes:
		position = parent_position
		return
	
	var viewport_base_size = get_viewport().size
	if get_viewport().content_scale_size > Vector2i.ZERO:
		viewport_base_size = get_viewport().content_scale_size
