@tool
class_name TreeDisplay
extends Node2D

@onready var node_box: Node2D = $NodesBox
@onready var node_connections: Node2D = $NodeConnections

@export_enum("gun", "laser", "area", "factory") var tree_name := "gun"

var _connected_nodes = {}
var selected_tower : TowerBase:
	set = set_tower

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
	var keys = node.influence_property_name.split(",")
	var values = node.influence_property_value.split(",")
	
	match node.influence_type:
		node.InfluenceType.CHANGE_PROPERTY:
			apply_stat(keys, values, "set_stat")
			
		node.InfluenceType.ADD_TO_PROPERTY:
			apply_stat(keys, values, "add_stat")


func apply_stat(keys: Array, values: Array, fname: String):
	var amount: int = min(keys.size(), values.size())
	for i in amount:
		selected_tower.call(fname, keys[i], values[i])


func set_tower(tower: TowerBase):
	selected_tower = tower

