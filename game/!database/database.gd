extends Node


var _data := {
	enemy = preload("uid://bmvdju2w8ahex"),
	tower = preload("uid://blxxfifblmdfe")
}


func get_enemies_lib() -> DataLib: return _data.enemy
func get_towers_lib() -> DataLib:  return _data.tower
