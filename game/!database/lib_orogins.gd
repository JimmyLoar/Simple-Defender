@tool
class_name DataLibOrigins
extends DataLib


var _origins := Dictionary()
var _counted := Dictionary()


func _init(new_data := {}) -> void:
	_data = new_data
	for key in new_data.keys():
		_origins[key] = {}
	recount_all_data()
	_logger.info("ready! Init data is '%s'" % _data)


func set_for_key(key: String, value):
	if not _data.has(key):
		_origins[key] = {}
	
	_data[key] = value
	recount_one_data(key)


func set_origin(key: String, origin: String, value):
	if not has(key): 
		_logger.warn("not found data with key '%s'" % [key])
		return 
	if check_same_type(key, value): 
		_logger.warn("value non type! Data type is '%s', value type is '%s'" %\
			[type_string(_data[key]), typeof(value)])
		return
	
	_origins[key][origin] = value


func get_for_key(key: String):
	if not has(key):
		return null
	
	elif not _counted.has(key):
		recount_one_data(key)
	
	return _counted[key]


func recount_all_data():
	for key in _data.keys():
		recount_one_data(key)


func recount_one_data(key: String):
	var origins := _origins[key] as Dictionary
	var origins_value = _data[key]
	for i in origins.size():
		if typeof(origins[i]) != typeof(origins_value):
			_logger.warn("value non type! Data type is '%s', value type is '%s'" %\
				[type_string(origins_value), typeof(origins[i])])
			continue
		
		origins_value += origins[i]
	
	_counted[key] = origins_value
	_logger.info("finalaze data '%s' counted, value '%s' " % [key, origins_value])


func check_same_type(key: String, value: Variant) -> bool:
	return typeof(_data[key]) == typeof(value)


func check_same_type_origins(key: String, origins: Dictionary):
	var data_type = typeof(_data[key])
	var function = func(value): return typeof(value) == data_type
	return origins.values().all(function)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	properties.append({
		name = "_origins",
		type = TYPE_DICTIONARY,
		usage = PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_EDITOR,
	})
	
	properties.append({
		name = "_counted",
		type = TYPE_DICTIONARY,
		usage = PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_EDITOR,
	})
	
	return properties
