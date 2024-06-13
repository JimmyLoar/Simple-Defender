class_name Level
extends Node2D

var _logger := GodotLogger.with("Level")


func _ready():
	_logger.info("ready!")


func get_tile_map() -> TileMap: return $TileMap
func get_tower_builder() -> Node2D: return $Builder
func get_enemy_keeper() -> EnemiesKeeper: return $EnemiesKeeper


