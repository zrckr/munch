class_name InputHint
extends Control

const ICON_TEXTURE_PATH = 'res://assets/icons/buttons/%s/%s.tres'
const STATUS_ICON_FALLBACK := preload('res://assets/icons/buttons/fallback.tres')
const INPUT_ICON_FALLBACK := preload('res://assets/icons/buttons/fallback.tres')

@export
var status_icon: Texture2D

# NOTE: Keep it sync with the InputMap
@export_enum('use', 'attack')
var input_action: String

@onready
var _status_texture_rect: TextureRect = %StatusIcon

@onready
var _input_texture_rect: TextureRect = %InputIcon


func _ready() -> void:
	_set_status_icon()
	_set_input_icon()


func show_input() -> void:
	_input_texture_rect.visible = true


func hide_input() -> void:
	_input_texture_rect.visible = false


func set_percentage(value: float) -> void:
	var percentage := clampf(value, 0.0, 1.0) / 10.0 + 0.88
	var shader := _status_texture_rect.material as ShaderMaterial
	shader.set_shader_parameter('percentage', percentage)


func _set_status_icon() -> void:
	if not status_icon:
		status_icon = STATUS_ICON_FALLBACK
	_set_icon_texture(_status_texture_rect, status_icon)


func _set_input_icon() -> void:
	if input_action:
		var path = ICON_TEXTURE_PATH % [Inputs.device, input_action]
		_set_icon_texture(_input_texture_rect, load(path))
	else:
		_set_icon_texture(_input_texture_rect, INPUT_ICON_FALLBACK)


func _set_icon_texture(texture_rect: TextureRect, texture: Texture2D) -> void:
	if texture_rect and texture:
		texture_rect.texture = texture
		texture_rect.custom_minimum_size = texture.get_size() / 1.5
