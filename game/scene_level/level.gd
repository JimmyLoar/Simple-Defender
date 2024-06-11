class_name Level
extends Node2D

var logger := GodotLogger.with("Level")

@onready var tile_map = $TileMap

func _ready():
	logger.info("ready!")


func get_cell_path():
	return []


func is_free_cell(cell_pos: Vector2i):
	return true

