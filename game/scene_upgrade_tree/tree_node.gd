@tool
class_name TreeNode
extends Marker2D

@export var skill_name := "Name"
@export var icon: Texture = preload('res://icon.svg'):
	set(value):
		icon = value
		if not is_inside_tree(): return
		ui.set_icon(icon)


@export var dependence: Array[TreeNode] = []
@export var prise = {
	"1": 0,
	"2": 0,
	"3": 0,
}


@export_group("UI Focus", "_ui")
@export var _ui_left: TreeNode
@export var _ui_right: TreeNode
@export var _ui_top: TreeNode
@export var _ui_bottom: TreeNode


@onready var ui: PanelContainer = $UI
@onready var connection_markers: Node2D = $ConnectNodes
@onready var button: Button = $UI/Button


func _ready() -> void:
	if Engine.is_editor_hint():
		connection_markers.set_connect_position(ui.size)
		ui.set_title(self.name)
	
	else:
		ui.set_title("Node")
		call_deferred("_update_focus_button")


func _update_focus_button():
	if _ui_left:
		button.focus_neighbor_left = _ui_left.button.get_path()
	if _ui_right:
		button.focus_neighbor_right = _ui_right.button.get_path()
	if _ui_top:
		button.focus_neighbor_top = _ui_top.button.get_path()
	if _ui_bottom:
		button.focus_neighbor_bottom = _ui_bottom.button.get_path()


func get_connect_points() -> Array[Node]:
	return connection_markers.get_children()


func get_left_marker() -> Marker2D:
	return connection_markers.left

func get_right_marker() -> Marker2D:
	return connection_markers.right

func get_down_marker() -> Marker2D:
	return connection_markers.down

func get_up_marker() -> Marker2D:
	return connection_markers.up
