#@tool
class_name TowerRadarCompanent
extends Area2D

signal targets_changed

@export_enum("None:-1", "Enemies:0", "Allies:1") var target_mode := 0: set = set_target_mode
@export_range(2.0, 64.0, 0.01) var vition_range := 1.0: set = set_vition_range

var collision : CollisionShape2D

var _logger : Log

var _queue_targets: Array[Node2D] = []


func _init():
	collision = CollisionShape2D.new()
	collision.shape = CircleShape2D.new() 
	set_vition_range(vition_range)
	add_child(collision)
	
	area_entered.connect(_on_target_entered)
	area_exited.connect(_on_target_exited)


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


func _get_logger():
	if _logger: return _logger
	var parent = get_parent() as TowerBase
	_logger = GodotLogger.with("%s.Radar" % [parent.tower_name if parent else "Nill"])
	return _logger


func _on_target_entered(new_target: Node2D):
	if _queue_targets.has(new_target): return
	_queue_targets.append(new_target)
	_logger.debug("found target %s" % new_target)
	targets_changed.emit()


func _on_target_exited(old_target: Node2D):
	if not _queue_targets.has(old_target): return
	_queue_targets.erase(old_target)
	_logger.debug("lost target %s" % old_target)
	targets_changed.emit()


func sort_targets():
	pass


func get_targets(count := 1) -> Array[Node2D]:
	return []


func get_first_target_or_null():
	if _queue_targets.is_empty(): return null
	return _queue_targets.front()
