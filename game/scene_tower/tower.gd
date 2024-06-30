class_name TowerBase
extends Node2D

@export var tower_name := "TowerBase"
@export var size := 1: set = set_size

@onready var radar = %Radar
@onready var body = %Body


@onready var properties := DataProperties.new()
var _logger: Log = GodotLogger.with("%s" % [self])


func _init() -> void:
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



