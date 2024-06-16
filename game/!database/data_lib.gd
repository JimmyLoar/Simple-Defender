class_name DataLib
extends Resource


@export var _data := {
	
}

var _logger := GodotLogger.with("DataLib")


func add_data(key, value):
	_data[key] = value
	_save()


func has(key: String):
	return _data.has(key)


func get_data(key: String):
	if not has(key): 
		_logger.warn("not found key %s, getting null data" % [key])
		return null
	return _data[key]


func _save():
	var err = ResourceSaver.save(self, self.resource_path)
	if err != OK: 
		_logger.error("cannot save data (%s), error %s" % [self.resource_path.get_file(), error_string(err)])
	
	else:
		_logger.debug("save data (%s) succes!" % [self.resource_path.get_file()])
