class_name Enemy
extends Area2D

signal finished(enemy: Enemy)

@export var enemy_name := "Normal"
@export var move_speed := 64

@onready var data: DataLib = Database.get_enemy_lib()
@onready var _logger := GodotLogger.with("%s" % self)

var is_death = false
var _hit_points := HitpointsCompanent.new(10)


func _init():
	ready.connect(_add_to_data)


func _ready() -> void:
	_hit_points._logger = _logger
	add_child(_hit_points)
	_logger.debug("add hp bar %s" % _hit_points)


func reset():
	_hit_points.reset()


func _add_to_data():
	var data_key: String = enemy_name.to_snake_case()
	if not data or data.has(data_key): return
	data.set_for_key(data_key, scene_file_path)


func _enter_tree():
	show()


func get_hit_points() -> HitpointsCompanent:
	return _hit_points


func is_dead():
	return _hit_points.is_dead()
