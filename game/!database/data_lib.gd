class_name DataLib
extends Resource


@export var _data := Dictionary()
@export var _data_unpacked := Dictionary()
var _logger:= GodotLogger.with("DataLib")


func _init(new_data := {}) -> void:
	_data = new_data
	_data_unpacked.clear()


func add_data(key, value):
	_data[key] = value


func has(key: String):
	return _data.has(key)


func get_scene(key: String) -> PackedScene:
	if not has(key): 
		_logger.warn("not found key '%s', getting null scene" % [key])
		_logger.info("existed keys: %s" % [_data.keys()])
		return null
	return _data[key]


func get_node(key: String, unique := true) -> Node:
	if not has(key): 
		_logger.warn("not found key '%s', getting null node" % [key])
		_logger.info("existed keys: %s" % [_data.keys()])
		return null
	
	elif not _data_unpacked.has(key):
		_data_unpacked[key] = _data[key].instantiate()
	
	if unique: return _data_unpacked[key].duplicate()
	return _data_unpacked[key]


func get_all_data() -> Dictionary:
	return _data


func _init_logger():
	_logger = GodotLogger.with("DataLib")




