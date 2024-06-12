class_name ChildArraySynhronizer

var parent: Node
var prototype: Node

var _pool := []

var logger := GodotLogger.with("ChildArraySynhronizer")


func _init(_parent: Node, _prototype: Node):
	parent = _parent
	prototype = _prototype
	logger.debug("created new synhronizer | parent %s | prototype %s" % [_parent, _prototype])


func synh_children(list: Array):
	var difference: int = parent.get_child_count() - list.size()
	if difference > 0: _add_childs(difference)
	elif difference < 0: _remove_childs(abs(difference))


func _add_childs(count: int = 1):
	for _i in count:
		var child = _get_child()
		parent.add_child(child)


func _get_child():
	if _pool.is_empty():
		return prototype.duplicate()
	return _pool.pop_front()


func _remove_childs(count: int = 1):
	for _i in count:
		var child = parent.get_child(0)
		parent.remove_child(child)
		_pool.append(child)

