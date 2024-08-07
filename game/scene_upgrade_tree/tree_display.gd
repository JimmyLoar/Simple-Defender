@tool
class_name TreeDisplay
extends Node2D

@onready var node_box: Node2D = $NodesBox
@onready var node_connections: Node2D = $NodeConnections

@export_enum("gun", "laser", "area", "factory") var tree_name := "gun"

var _connected_nodes = {}
var selected_tower : TowerBase:
	set = set_tower

var _unlocked_skills: PackedStringArray = []
var currency : CurrencySystem


func _ready() -> void:
	connection_nodes()
	call_deferred("is_avaible_unlock", $NodesBox/T1/Root)


func connection_nodes():
	for tree: SubTree in node_box.get_children():
		tree.conection_nodes()


func set_unlock_skills(list: PackedStringArray):
	if list.is_empty():
		_unlocked_skills = [$NodesBox/T1/Root.get_skill_name()]
	
	else:
		_unlocked_skills = list
	
	for tree: SubTree in node_box.get_children():
		for node: TreeNode in tree.get_children():
			node.set_unlock(_unlocked_skills.has(node.get_skill_name()))


func get_unlock_skills() -> PackedStringArray:
	return _unlocked_skills 


func is_avaible_unlock(node: TreeNode):
	if node.is_unlock(): 
		return
	
	var prise_list: Dictionary = node.prise
	if not prise_list.keys().all(
		func(key): 
			if prise_list[key] <= 0: return true
			return currency.check_to_value(key, prise_list[key])
	):
		return 
	
	prise_list.keys().all(
		func(key): 
			return currency.change(key, prise_list[key] * -1)
	)
	
	node.unlock()
	
	_unlocked_skills.append(node.get_skill_name())
	if not selected_tower or node.skill_data["influence_type"].is_empty():
		return
	
	apply_stat(node.skill_data["influence_key"], node.skill_data["influence_value"], node.skill_data["influence_type"])


func apply_stat(keys: Array, values: Array, types: Array):
	var amount: int = mini(mini(keys.size(), values.size()), types.size())
	for i in amount:
		selected_tower.add_stat(keys[i], values[i], types[i])


func set_tower(tower: TowerBase):
	if selected_tower:
		selected_tower.unlocked_skills = get_unlock_skills()
	
	selected_tower = tower
	set_unlock_skills(tower.unlocked_skills)

