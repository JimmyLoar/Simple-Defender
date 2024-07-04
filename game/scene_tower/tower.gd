class_name TowerBase
extends Node2D

@export var tower_name := "TowerBase"
@export var size := 1: set = set_size
@export var base_stats := {
	"damage": 1.0,
	"firerate": 1.0,
	"vision_range": 1.0,
}:
	get = get_stats

@onready var radar = %Radar
@onready var body = %Body


@onready var properties := DataProperties.new()
var _logger: Log = GodotLogger.with("%s" % [self])


func _init() -> void:
	if not ready.is_connected(_update_info):
		ready.connect(_update_info)


func _update_info():
	name = tower_name
	_logger.debug("tower has %s and %s" % [$Radar, $Body])


func set_size(value: int):
	if not is_inside_tree():
		return
	
	size = clamp(value, 1, 16)
	$Body.set_size(size)
	_logger.debug("set size on %d (%s tiles)" % [size, size * size])


func get_stats() -> Dictionary:
	var stats = base_stats.duplicate(true)
	stats.merge(_get_stats())
	return stats


func _get_stats() -> Dictionary:
	return {}
