class_name EntityState
extends Resource

@export var name: String
@export var lifetime: float
@export var health: int

@export_group('Transform')
@export var transform: Transform2D
@export var direction: Vector2
@export var speed: float

@export_group('Animation', 'animation_')
@export var animation_name: String
@export var animation_position: float
