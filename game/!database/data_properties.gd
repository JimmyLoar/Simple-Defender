class_name DataProperties
extends Resource

@export var _data := Dictionary()


var _logger = GodotLogger.with("DataProperties")


func add_property(key: StringName, origin: StringName, value: Variant):
	var data: Dictionary = _data[key]
	if has_origin(key, origin):
		data[origin] = value


func set_property(key: StringName, origin: StringName = "base", value: Variant = null):
	if not has_property(key):
		_add_new_property(key, type_convert(null, typeof(value)))
	
	_data[key][origin] = value


func has_property(key: StringName) -> bool:
	return _data.has(key)


func has_origin(key: StringName, origin: StringName) -> bool:
	if not has_property(key): return false
	return _data[key].has(origin)


func get_property(key: StringName):
	if not has_property(key): return null
	return _data[key].all
	


func _get_amount_propery(property_key: StringName) -> Variant:
	var data: Dictionary = _data[property_key]
	var values = data.base
	for origin in data.keys():
		var value = data[origin]
		if origin == &"base" or origin == &"all": continue
		if typeof(value) != values:
			_logger.warn("origin '%s' wrong type '%s', base type '%s'" % [
				origin, type_string(typeof(value)), type_string(typeof(data.base))
			])
			continue
		
		values += value
	
	set_property(property_key, &"all", values)
	return values 


func _add_new_property(key: StringName, value: Variant) -> bool:
	if has_property(key): 
		return false
	
	var data = Dictionary()
	data[&"base"] = value
	data[&"all"]= value
	_data[key] = data
	return true
