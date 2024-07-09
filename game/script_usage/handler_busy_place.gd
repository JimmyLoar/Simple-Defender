class_name BusyPlaceChecker
extends Resource

var _busy_place : PackedVector2Array = []


func add_busy_place(place: Vector2) -> bool:
	if is_busy_place(place): 
		return false
	
	_busy_place.append(place)
	return true


func add_busy_array(array) -> bool:
	if not _array_is_array(array): 
		return false
	
	for place: Vector2 in array:
		if not place: continue
		add_busy_place(place)
	return true


func remove_busy_place(_place: Vector2):
	pass


func remove_busy_array(_array):
	pass


func is_busy_place(place: Vector2) -> bool:
	return _busy_place.has(place)


func is_free_place(place: Vector2) -> bool:
	return not is_busy_place(place)


func is_free_array(array):
	if not _array_is_array(array): return
	for place: Vector2 in array:
		if not place: continue
		if is_busy_place(place):
			return false
	return true


func _array_is_array(array) -> bool:
	return typeof(array) == TYPE_ARRAY or typeof(array) == TYPE_PACKED_VECTOR2_ARRAY
