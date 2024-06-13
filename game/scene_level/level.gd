class_name Level
extends Node2D

var _logger := GodotLogger.with("Level")


func _ready():
	_logger.info("ready!")


func get_tile_map(): return $TileMap
func get_tower_builder(): return $Builder
func get_enemy_keeper(): return $EnemiesKeeper

