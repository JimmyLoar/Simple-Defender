#@tool
class_name TowerBodyCompanent
extends StaticBody2D

var collition : CollisionShape2D

@onready var _logger: Log = GodotLogger.with("%s.Body" % [get_parent()])


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


func take_damage(damage: int):
	_logger.info("taked damage %d" % [damage])
