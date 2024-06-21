@tool
extends Node


var _data := {
	tower = DataLib.new({
		&"gun_main": preload('res://resources/towers/gun/gun_main.tres'),
		&"gun_a": preload('res://resources/towers/gun/gun_a.tres'),
		&"gun_b": preload('res://resources/towers/gun/gun_b.tres'),
		&"gun_c": preload('res://resources/towers/gun/gun_c.tres'),
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



