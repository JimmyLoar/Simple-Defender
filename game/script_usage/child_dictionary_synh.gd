class_name ChildDictionarySynhronizer
extends ChildSynhronizer

var func_name: String


func _init(_parent: Node, _prototype: Node, _func_name: String):
	parent = _parent
	prototype = _prototype
	func_name = _func_name
	logger.debug("created new child synhronizer | parent %s | prototype %s | callible '%s'" % [_parent, _prototype, func_name])


func synhonize(value: Variant):
	if typeof(value) != TYPE_DICTIONARY: return
	_synh(value.size() - parent.get_child_count(), value)


func _synh(difference: int, dict: Dictionary = {}):
	if difference > 0: _add_childs(difference)
	elif difference < 0: _remove_childs(abs(difference))
	_update(dict)


func _update(dict: Dictionary):
	for x in parent.get_child_count():
		var child = parent.get_child(x)
		var key = dict.keys()[x]
		child.callv(func_name, [key, dict[key]])
		
