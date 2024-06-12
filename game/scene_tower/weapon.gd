class_name TowerWeapon
extends Node2D

var main_target : Node2D
var targets: Array[Node2D] = []

var _logger: Log : get = _get_logger 
func _get_logger():
	if _logger: return _logger
	var parent = get_parent() as TowerBase
	_logger = GodotLogger.with("%s.Radar" % [parent.tower_name if parent else "Nill"])
	return _logger


func _target_chenged(radar: TowerRadarCompanent):
	if not radar: return
	targets = radar.get_target()
	main_target = targets.front()


func shoot():
	_get_logger().debug("shoting")


