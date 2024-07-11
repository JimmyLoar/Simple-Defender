@tool
class_name UpgradeTree
extends Resource

@export var data: Array[UpgradeData] = []: 
	set = set_data

var _index_dictionary: Dictionary = {}

@export var _dependencies: Dictionary = {}
@export var _base_price: Dictionary = {}


func set_data(value: Array):
	if data == value: return
	data = value
	if not Engine.is_editor_hint(): return
	_connect_change_signal()
	_update_properties()


func _connect_change_signal():
	for upgrade: UpgradeData in data:
		if not upgrade: continue
		if not upgrade.changed.is_connected(_update_properties):
			upgrade.changed.connect(_update_properties)


func _update_properties():
	_update_index_dictionary()
	_update_prise_dictionary()
	_update_dependence_dictionary()
	GodotLogger.info("upgrade tree updated")


func _update_index_dictionary():
	_index_dictionary.clear()
	for i in data.size():
		var upgrade: UpgradeData = data[i]
		_index_dictionary[upgrade._name] = i


func _update_prise_dictionary():
	_base_price = _index_dictionary.duplicate()


func _update_dependence_dictionary():
	var new_dictionady := {}
	for key in _index_dictionary.keys():
		if not _dependencies.has(key): 
			new_dictionady[key] = ""
			continue
		new_dictionady[key] = _dependencies[key]
	
	_dependencies = new_dictionady


func get_index_for_key(key: String) -> int:
	if not _index_dictionary.has(key):
		return -1
	return _index_dictionary[key]


func get_key_from_index(index: int):
	if index >= data.size() or index < 0:
		return ""
	return data[index]._name


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		name = "_index_dictionary",
		type = TYPE_DICTIONARY,
		usage = PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT,
	})
	
	
	properties.append({
		name = "_dependencies",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = ", ".join(PackedStringArray(_index_dictionary.keys())).capitalize(),
	})
	
	return properties

