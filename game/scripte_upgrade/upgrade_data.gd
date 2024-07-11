@tool
class_name UpgradeData
extends Resource

@export var _name: StringName = &"":
	set(value):
		if _name == value: return
		_name = value
		emit_changed()

@export var _icon: Texture = preload('res://icon.svg'):
	set(value):
		_icon = value
		emit_changed()

var _dependencies: Array[StringName] = ["", "", ""]


func _get_property_list() -> Array[Dictionary]:
	var data_names = PackedStringArray(Database.get_upgrade_lib().get_all_data().keys())
	var properties: Array[Dictionary] = []
	properties.append({
		name = "_dependencies",
		type = TYPE_ARRAY,
		hint = PROPERTY_HINT_TYPE_STRING,
		hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM_SUGGESTION, ",".join(data_names)],
	})
	
	return properties
