@tool
class_name TreeNode
extends Marker2D

signal unloked(node: TreeNode)


@export var dependence: Array[TreeNode] = []
@export var prise = {
	"money":  0,
	"energy": 0,
	"scrap":  0,
}


@export_group("UI Focus", "_ui")
@export var _ui_left: TreeNode
@export var _ui_right: TreeNode
@export var _ui_top: TreeNode
@export var _ui_bottom: TreeNode


var base_skill: StringName = &"none"

var _unlocked := false


@onready var ui: PanelContainer = $UI
@onready var connection_markers: Node2D = $ConnectNodes
@onready var button: Button = $UI/Button

@onready var skill_data : Dictionary 


func _ready() -> void:
	var lib : DataLib = Database.get_skill_lib()
	skill_data = lib.get_data(base_skill)
	skill_data.merge(lib.get_data(&"none"))
	
	if Engine.is_editor_hint():
		connection_markers.set_connect_position(ui.size)
		ui.set_title(self.name)
		ui.set_icon(skill_data.icon)
	
	else:
		call_deferred("_update_focus_button")
		update()
		_connect_to_deperance()


func update():
	ui.set_title(skill_data.name)
	ui.set_icon(skill_data.icon)
	modulate = Color.WHITE if is_dependence_unlocked() else Color(1, 1, 1, 0.5)


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


func is_unlock() -> bool: return _unlocked


func is_dependence_unlocked() -> bool:
	if dependence.is_empty(): return true
	return dependence.all(
		func(node: TreeNode):
			return node.is_unlock()
	)


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
