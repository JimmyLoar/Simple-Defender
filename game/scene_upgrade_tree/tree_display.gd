@tool
class_name TreeDisplay
extends Node2D

@onready var node_box: Node2D = $NodesBox
@onready var node_connections: Node2D = $NodeConnections

var _connected_nodes = {}

func _ready() -> void:
	connection_nodes()
	is_avaible_unlock($NodesBox/T1/Root)


func connection_nodes():
	for tree: SubTree in node_box.get_children():
		tree.conection_nodes()


func set_unlock_skills(list: Array):
	pass


func get_unlock_skills() -> Array:
	return []


func is_avaible_unlock(node: TreeNode):
	node.unlock()


