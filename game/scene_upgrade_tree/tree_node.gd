@tool
class_name TreeNode
extends Marker2D

signal want_unlock(node: TreeNode)
signal unloked

@export var dependence: Array[TreeNode] = []
@export var prise = {
	"money":  0,
	"energy": 0,
	"scrap":  0,
}


enum InfluenceType{NONE, CHANGE_PROPERTY, ADD_TO_PROPERTY,}
@export_group("Influence", "influence_")
@export var influence_type : InfluenceType = InfluenceType.NONE
@export var influence_property_name := ""
@export var influence_property_value := ""


@export_group("UI Focus", "_ui")
@export var _ui_left: TreeNode
@export var _ui_right: TreeNode
@export var _ui_top: TreeNode
@export var _ui_bottom: TreeNode


var base_skill: StringName = &"none":
	set(value):
		base_skill = value
		_update_influence(value)
var logger := GodotLogger.with("%s" % self)

var _unlocked := false


@onready var ui: PanelContainer = $UI
@onready var connection_markers: Node2D = $ConnectNodes
@onready var button: Button = $UI/Button

@onready var skill_data : Dictionary 


func _ready() -> void:
	var lib : DataLib = Database.get_skill_lib()
	skill_data = lib.get_for_key(base_skill)
	skill_data.merge(lib.get_for_key(&"none"))
	logger.debug("loaded skill data '%s': %s" % [base_skill, skill_data])
	
	if Engine.is_editor_hint():
		connection_markers.set_connect_position(ui.size)
		ui.set_title(self.name)
		ui.set_icon(skill_data.icon)
	
	else:
		update()
		call_deferred("_update_focus_button")
		_connect_to_deperance()
	
	logger.debug("ready!")
	button.button_pressed = true


func update():
	ui.set_title(skill_data.name)
	ui.set_icon(skill_data.icon)
	if is_unlock():
		modulate = Color.LIGHT_SALMON
	
	else:
		modulate = Color.WHITE if is_dependence_unlocked(false) else Color(1, 1, 1, 0.5)


func get_connect_markers() -> Array[Node]:
	return connection_markers.get_children()


func get_left_marker() -> Marker2D:
	return connection_markers.left

func get_right_marker() -> Marker2D:
	return connection_markers.right

func get_down_marker() -> Marker2D:
	return connection_markers.down

func get_up_marker() -> Marker2D:
	return connection_markers.up


func unlock():
	if not is_dependence_unlocked(false):
		return
	
	_unlocked = true
	update()
	unloked.emit()


func is_unlock() -> bool: return _unlocked


func is_dependence_unlocked(is_all := true) -> bool:
	if dependence.is_empty(): return true
	var function = func(node: TreeNode):
		if not node is TreeNode: return true
		return node.is_unlock()
	if is_all: return dependence.all(function)
	else: return dependence.any(function)


func _connect_to_deperance():
	for node: TreeNode in dependence:
		node.unloked.connect(update)


func _update_focus_button():
	if _ui_left:
		button.focus_neighbor_left = _ui_left.button.get_path()
	if _ui_right:
		button.focus_neighbor_right = _ui_right.button.get_path()
	if _ui_top:
		button.focus_neighbor_top = _ui_top.button.get_path()
	if _ui_bottom:
		button.focus_neighbor_bottom = _ui_bottom.button.get_path()


var _skill_names: Array = Database.get_skill_keys()
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	properties.append({
		name = "base_skill",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM_SUGGESTION,
		hint_string = ",".join(PackedStringArray(_skill_names)),
	})
	

	return properties


func _pressed() -> void:
	want_unlock.emit(self)


func _update_influence(value: String):
	var data: Dictionary = Database.get_skill_lib().get_for_key(value)
	if not data.has("influence_type") or data.influence_type == TreeNode.InfluenceType.NONE \
		or influence_type != InfluenceType.NONE:
		return
	 
	influence_type = data.influence_type
	influence_property_name = data.influence_name
	influence_property_value = data.influence_value
	notify_property_list_changed()
