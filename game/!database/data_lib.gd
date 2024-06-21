class_name DataLib
extends Resource


@export var _data:= Dictionary()
var _logger:= GodotLogger.with("DataLib")


func _init(new_data := {}) -> void:
	_data = new_data


func add_data(key, value):
	_data[key] = value


func has(key: String):
	return _data.has(key)


func get_data(key: String):
	if not has(key): 
		_logger.warn("not found key %s, getting null data" % [key])
		return null
	return _data[key]


func get_all_data() -> Dictionary:
	return _data


func _init_logger():
	_logger = GodotLogger.with("DataLib")




