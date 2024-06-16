extends Node


var _data := {
	enemy = preload("res://game/!database/libs/enemies.tres"),
	tower = preload("res://game/!database/libs/towers.tres")
}


func get_enemies_lib() -> DataLib: return _data.enemy
func get_towers_lib() -> DataLib:  return _data.tower
