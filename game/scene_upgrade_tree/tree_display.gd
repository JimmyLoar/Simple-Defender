@tool
class_name SkillTree
extends Node2D

@onready var node_box: Node2D = $NodesBox
@onready var node_connections: Node2D = $NodeConnections

var _connected_nodes = {}

func _ready() -> void:
	connect_node()


func connect_node():
	for node: TreeNode in node_box.get_children():
		if node.dependence.is_empty():
			continue
		
		for to_node: TreeNode in node.dependence:
			if not to_node: continue
			_update_connection(node, to_node)


func _create_connect_line() -> Line2D:
	var line := Line2D.new()
	node_connections.add_child(line)
	
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ONE)
	
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	return line


func _update_connection(from_node: TreeNode, to_node: TreeNode):
	var line_key = [from_node.get_path(), to_node.get_path()]
	var line: Line2D
	if not _connected_nodes.has(line_key): 
		line = _create_connect_line() 
		_connected_nodes[line_key] = line
	
	else:
		line = _connected_nodes[line_key]
	
	var start_index := 0
	var start_pos := from_node.get_down_marker().global_position - line.global_position
	line.points[start_index] = start_pos#.set(start_index, start_pos)
	
	var end_index := line.points.size() - 1
	var end_pos = to_node.get_up_marker().global_position - line.global_position
	line.points[end_index] = end_pos
	

