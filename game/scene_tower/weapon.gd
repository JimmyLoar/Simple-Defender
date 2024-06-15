class_name TowerWeapon
extends Node2D

var main_target : Node2D
var targets: Array[Node2D] = []
var radar : TowerRadarCompanent

var _logger: Log : get = _get_logger 
func _get_logger():
	if _logger: return _logger
	var parent = get_parent() as TowerBase
	_logger = GodotLogger.with("%s.Radar" % [parent.tower_name if parent else "Nill"])
	return _logger


func _target_chenged(_radar: TowerRadarCompanent):
	if not _radar: return
	radar = _radar
	targets = radar.get_target()
	main_target = targets.front()


func _physics_process(delta):
	if main_target:
		look_at(main_target.global_position)
	
	else:
		_find_target()


func _find_target():
	if not radar: return
	main_target = radar.get_first_target_or_null()


func _shoot():
	_get_logger().debug("shoting")


