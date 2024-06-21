class_name DataTower
extends Resource

@export_range(0, pow(2, 31), 1) var base_damage: int = 10
@export_range(0.5, 32, 0.01) var base_vision_range: float = 4.0
@export_range(0.008, 30, 0.001) var base_firerate_in_second: float = 1.0

@export var projectile: PackedScene

var _logger = GodotLogger.with("DataTower")





