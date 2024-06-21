@tool
extends Node


var _data := {
	tower = DataLib.new({
	}),
	enemy = DataLib.new({
		
	}),
	level = DataLib.new({
		
	}),
}


@onready var _logger := GodotLogger.with("Database")

func get_enemies_lib() -> DataLib: return _data.enemy
func get_towers_lib() -> DataLib:  return _data.tower


func _ready() -> void:
	_logger.info("database has libs '%s'" % _data)



