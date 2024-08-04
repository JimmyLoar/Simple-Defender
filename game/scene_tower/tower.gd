class_name TowerBase
extends Node2D

signal stats_changed

const IGNOR_STAT_KEYS = [
	"weapon", "projectile"
]

@export_enum("gun", "laser", "area", "factory") var tree_name := "gun"
@export var tower_name := "TowerBase"
@export var size := 1: set = set_size
@export var base_stats := {
	"damage": 1.0,
	"firerate": 1.0,
	"vision_range": 1.0,
}

@export var upgrade_tree: PackedScene

@export var new_stats: DataLibOrigins

@onready var radar = %Radar
@onready var body = %Body


@onready var properties := DataProperties.new()
var unlocked_skills: PackedStringArray = []
var _logger: Log = GodotLogger.with("%s" % [self])


func _init() -> void:
	if not ready.is_connected(update):
		ready.connect(update)


func _ready() -> void:
	new_stats = DataLibOrigins.new(base_stats)


func update() -> void:
	_update_info()
	_update_size()


func _update_info():
	name = tower_name
	_logger.debug("tower has %s and %s" % [$Radar, $Body])


func _update_size():
	$Body.set_size(size)
	_logger.debug("set size on %d (%s tiles)" % [size, size * size])


func set_size(value: int):
	size = clamp(value, 1, 16)
	if is_inside_tree():
		_update_size()


func set_stat(key: String, value: Variant):
	base_stats[key] = value
	stats_changed.emit(self)
	printerr("set stats | new stats %s" % base_stats)


func add_stat(key: String, value: Variant):
	if base_stats.has(key):
		base_stats[key] += convert(value, typeof(base_stats[key]))
		stats_changed.emit(self)
		printerr("add stats | new stats %s" % base_stats)
		return
	set_stat(key, value)


func get_stats(is_dysplay := false) -> Dictionary:
	var stats = base_stats.duplicate(true)
	stats.merge(_get_stats())
	stats = stats.duplicate(true)
	if is_dysplay:
		for key in stats.keys():
			if not IGNOR_STAT_KEYS.has(key):
				continue
			stats.erase(key)
	return stats



func _get_stats() -> Dictionary:
	return {}

