class_name TowerBase
extends Node2D

signal stats_changed(tower: TowerBase)

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
@export var _skill_stats: Dictionary = {}

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


func set_stat(key: String, value: Variant, type: int = TYPE_INT):
	var _old = get_stats()[key] 
	if base_stats.has(key):
		value += base_stats[key]
	_skill_stats[key] = convert(value, type)
	_logger.debug("SET skill stat '%s' on '%s' (%s) | old '%s'" % [key, value, get_stats()[key], _old])
	stats_changed.emit(self)


func add_stat(key: String, value: Variant, type: int):
	if _skill_stats.has(key):
		var _old = get_stats()[key] 
		_skill_stats[key] += convert(value, type)
		stats_changed.emit(self)
		_logger.debug("ADD skill stat '%s' on '%s' (%s) | old '%s'" % [key, value, get_stats()[key], _old])
		return
	
	#if base_stats.has(key) and typeof(value) != TYPE_STRING and typeof(value) != TYPE_OBJECT:
		#value += base_stats[key]
	set_stat(key, value, type)


func get_stats() -> Dictionary:
	var stats = base_stats.duplicate(true)
	stats.merge(_get_stats(), true)
	return stats


func _get_stats() -> Dictionary:
	return _skill_stats

