class_name TowerBase
extends Node2D

@export var tower_name := "TowerBase"
@export var size := 1: set = set_size


@onready var radar = $TowerRadar
@onready var body = $BodyCompanent


var _logger: Log : get = _get_logger


func set_size(value: int):
	if not is_inside_tree(): 
		call_deferred("set_size", value)
		return
	
	size = clamp(value, 1, 16)
	$BodyCompanent.set_size(size)
	#queue_redraw()
	_get_logger().debug("set size on %d (%s tiles)" % [size, size * size])


func _get_logger():
	if _logger: return _logger
	_logger = GodotLogger.with("%s.Scene" % [tower_name])
	return _logger

