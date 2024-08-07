class_name EnemiesKeeper
extends Node2D

signal path_cleared

@export_range(1, 8, 1) var path_count := 1

@export_group("Generation", "_gen_")
@export var _gen_min_count_in_wave := 5
@export var _gen_grow_count_from_wave := 0.1
@export var _gen_max_count_in_wave := 10

var _clearing_path := []
var _logger := GodotLogger.with("EnemiesKeeper")


func generate_wave(wave: int = 0):
	var enemy_count : int = min(_gen_min_count_in_wave + float(wave * _gen_grow_count_from_wave), _gen_max_count_in_wave)
	get_child(0).spawn_any(enemy_count)


func _ready():
	_connection_paths()


func _connection_paths():
	for path: EnemiesPath in get_children():
		var err = path.enemies_is_ever.connect(_on_enemies_is_over.bind(path))
		_logger.debug("connect path [color=yellow]%s[/color] error is '%s'" % [path, err])


func _on_enemies_is_over(path: EnemiesPath):
	if _clearing_path.has(path):
		_logger.warn("path %s duble clearing" % path)
		return
	
	_clearing_path.append(path)
	if _clearing_path.size() == get_child_count():
		_clearing_path.clear()
		_logger.info("all paths cleared!")
		GodotLogger.info("")
		path_cleared.emit()
		return
	_logger.debug("path [color=yellow]%s[/color] clear!" % path)


