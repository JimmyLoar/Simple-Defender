class_name Enemy
extends Area2D

signal dead(enemy: Enemy)
signal finished(enemy: Enemy)

@export var enemy_name := "Normal"
@export var move_speed := 64

@onready var data: DataLib = Database.get_enemies_lib()

func _init():
	ready.connect(_add_to_data)


func _add_to_data():
	var data_key: String = enemy_name.to_snake_case()
	if not data or data.has(data_key): return
	data.add_data(data_key, scene_file_path)


func death():
	emit_signal("dead", self)
