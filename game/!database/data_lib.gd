class_name DataLib
extends Resource

@export var _data := Dictionary()

var _logger:= GodotLogger.with("DataLib: <%s>" % self.get_instance_id())


func _init(new_data := {}) -> void:
	_data = new_data
	_logger.info("ready! Init data is '%s'" % _data)


func set_for_key(key: String, value):
	_data[key] = value
	_logger.debug("set '%s' value '%s'" %[key, value])


func has(key: String, is_packed_scene := false) -> bool:
	var _has = _data.has(key)
	if is_packed_scene and _has:
		return _has && _data[key] is PackedScene
	return _has


func get_for_key(key: String) -> Variant:
	if key == "": return null
	if not has(key): 
		_logger.warn("not found data with key '%s', getting 'null'" % [key])
		_logger.info("existed keys: %s" % [_data.keys()])
		return null
	return _data[key]


func get_all_data() -> Dictionary:
	return _data






