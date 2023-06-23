@icon('res://editor/icons/resource.png')
class_name EntityState
extends Resource

@export_group('Collision')
@export var collision_priority: float

@export_group('Health')
@export var health_points: int
@export var is_invulnerable: bool

@export_group('Lifetime')
@export var duration_time: float

@export_group('Movement')
@export var position: Vector2
@export var direction: Vector2
@export var speed: float

@export_group('Animation')
@export var animation_name: String
@export var animation_position: float

@export_group('Hurtbox')
@export var hurtbox_enabled: bool

@export_group('Hitbox')
@export var hitbox_enabled: bool
@export var hitbox_damage: int

@export_group('Munchbox')
@export var munchbox_enabled: bool
@export var munchbox_eaten: int
@export var munchbox_total: int
