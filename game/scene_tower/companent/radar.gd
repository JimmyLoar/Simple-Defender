@tool
class_name TowerRadarCompanent
extends Area2D

@export_enum("None:-1", "Enemies:0", "Allies:1") var target_mode := 0: set = set_target_mode
@export_range(2.0, 64.0, 0.01) var vition_range := 1.0: set = set_vition_range

var collision : CollisionShape2D

var _logger : Log



func set_target_mode(value: int = -1):
	if not is_inside_tree():
		call_deferred("set_target_mode", value)
		return
	
	target_mode = value
	collision.disabled = target_mode < 0
	match target_mode:
		0: collision_mask = 20.0
		1: collision_mask = 10.0
	
	_get_logger().debug("set target mode %s, mask %d" % [["None", "Enemies", "Allies"][target_mode + 1], collision_mask])


func set_vition_range(value: float):
	if not is_inside_tree():
		call_deferred("set_vition_range", value)
		return
	
	vition_range = value
	var cell_size = ProjectSettings.get_setting("game/level/cell/size", 64)
	collision.shape.radius = (vition_range - 0.5) * cell_size 
	_get_logger().debug("set vision range on %0.2f tiles" % [vition_range])


func _enter_tree():
	collision = CollisionShape2D.new()
	collision.shape = CircleShape2D.new() 
	set_vition_range(vition_range)
	add_child(collision)


func _get_logger():
	if _logger: return _logger
	var parent = get_parent() as TowerBase
	_logger = GodotLogger.with("%s.Radar" % [parent.tower_name if parent else "Nill"])
	
	return _logger
