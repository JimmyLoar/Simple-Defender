class_name TowerBase
extends Node2D

@export var tower_name := "TowerBase"
@export var size := 1: set = set_size

@onready var radar = %Radar
@onready var body = %Body

@onready var data := Database.get_towers_lib()
@onready var _logger: Log = GodotLogger.with("%s" % [self])


func _init():
	if not ready.is_connected(_add_to_data):
		ready.connect(_add_to_data)


func _add_to_data():
	var data_key: String = tower_name.to_snake_case()
	if not data or data.has(data_key): return
	data.add_data(data_key, scene_file_path)


func set_size(value: int):
	if not is_inside_tree(): 
		call_deferred("set_size", value)
		return
	
	size = clamp(value, 1, 16)
	$Body.set_size(size)
	_logger.debug("set size on %d (%s tiles)" % [size, size * size])


