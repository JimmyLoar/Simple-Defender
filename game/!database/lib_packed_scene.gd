extends DataLib
class_name DataLibPackedScene

@export var _data_unpacked := Dictionary()


func get_node(key: String, unique := true) -> Node:
	if not has(key, true): 
		_logger.warn("not found PackedScene with key '%s', getting 'null' node" % [key])
		_logger.info("existed keys: %s" % [_data.keys()])
		return null
	
	elif not _data_unpacked.has(key):
		_data_unpacked[key] = _data[key].instantiate()
	
	if unique: return _data_unpacked[key].duplicate()
	return _data_unpacked[key]
