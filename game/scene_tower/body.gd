@tool
class_name TowerBody
extends StaticBody2D

var collition : CollisionShape2D

var _logger: Log

func set_size(value:int):
	var cell_size: int = ProjectSettings.get_setting("game/level/cell/size", 64)
	collition.shape.size = Vector2.ONE * cell_size * value


func _enter_tree():
	var parent = get_parent() as TowerBase
	if not parent: return
	collition = CollisionShape2D.new()
	collition.shape = RectangleShape2D.new()
	set_size(parent.size)
	add_child(collition)


func _get_logger():
	if _logger: return _logger
	var parent = get_parent() as TowerBase
	_logger = GodotLogger.with("%s.Body" % [parent.tower_name if parent else "UnknowTower"] ) 
	return _logger
