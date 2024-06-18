class_name Level
extends Node2D

@export var _place_cheker : BusyPlaceChecker

var _logger := GodotLogger.with("Level")


func _ready():
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(0))
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(1))
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(2))
	_logger.info("ready!")


func get_tile_map() -> TileMap: return %TileMap
func get_tower_builder() -> Node2D: return %Builder
func get_enemy_keeper() -> EnemiesKeeper: return %EnemiesKeeper


