class_name TowerBuilder
extends Node2D

@export var prise_list = [100, 100, 100, 100]

var place_cheker: BusyPlaceChecker
var currency: CurrencySystem

var _cursor := HalographicCursor.new()
var _logger := GodotLogger.with("Builder")

var _builed_towers: Dictionary = {}
var _last_pressed := -1


func init_cursor() -> void:
	add_child(_cursor)
	_cursor.place_cheker = place_cheker
	_cursor.set_level_size(get_parent().get("size"))


const BUILD_PRESSED = {
	"buuild_tower_1" = 'gun_main',
	"buuild_tower_2" = 'gun_a',
	"buuild_tower_3" = 'gun_b',
	"buuild_tower_4" = 'gun_c',
}

func _input(event: InputEvent) -> void:
	var key = _get_key_pressed_tower(event)
	if key != "":
		if not is_building_mode():
			_cursor.change_mode(_cursor.Mode.BUILD)
			_cursor.set_tower_name(BUILD_PRESSED[key])
			return
		
		elif is_building_mode():
			_cursor.set_tower_name("")
			_cursor.change_mode(_cursor.Mode.NONE)
	
	
	if (event.is_action_pressed('ui_select') or event.is_action("mouse_lclick"))\
		and is_building_mode():
		if place_cheker.is_free_place(_cursor.get_cell_position()):
			build_tower(_cursor.select_tower)
			_cursor.queue_redraw()


func _get_key_pressed_tower(event):
	for key: String in BUILD_PRESSED.keys():
		if not event.is_action_released(key):
			continue
		_last_pressed = key.to_int()
		return key
	
	_last_pressed = -1
	return ""


func build_tower(tower_name: String):
	if not _cursor.can_build(): 
		return
	
	if not currency.check_to_value("money", prise_list[_last_pressed]):
		return
	
	currency.change("money", prise_list[_last_pressed] * -1)
	var tower = _get_new_tower_from_database(tower_name)
	
	if not tower: 
		return
	
	add_tower(tower, _cursor.get_cell_position(), _cursor.get_center_offset())


func switch_tower(new_tower_name: String, old_cell_position: Vector2i):
	var new_tower: TowerBase = _get_new_tower_from_database(new_tower_name)
	if not new_tower: return
	remove_tower(old_cell_position)
	add_tower(new_tower, old_cell_position, get_center_offset(new_tower.size))


func add_tower(tower: TowerBase, tower_pos: Vector2i, position_offset: Vector2 = Vector2.ZERO):
	var used_cells = _cursor.get_cells_position_list(tower_pos)
	place_cheker.add_busy_array(used_cells)
	tower.position = Vector2(tower_pos * _cursor.cell_size) + position_offset
	add_child(tower)
	for pos in used_cells:
		_builed_towers[pos] = tower
	_logger.debug("builded tower %s for %s | %s" % [tower.tower_name, _cursor.get_cell_position(), tower.position])


func remove_tower(cell_position: Vector2i):
	if not _builed_towers.has(cell_position): return
	var tower: TowerBase = _builed_towers[cell_position]
	var used_cells = _cursor.get_cells_position_list(cell_position)
	tower.queue_free()
	for pos in used_cells:
		_builed_towers.erase(pos)


func change_tower(old: TowerBase, new: TowerBase):
	remove_child(old)
	new.position = old.position
	add_child(new)


func get_center_offset(size: int) -> Vector2:
	return (Vector2.ONE * size * _cursor.cell_size) / 2.0


func get_center_position(cell_position: Vector2i, size: int) -> Vector2:
	return Vector2(cell_position * _cursor.cell_size) + get_center_offset(size)



func get_tower_below_cursor():
	var _pos = _cursor.get_cell_position()
	if _builed_towers.has(_pos):
		return _builed_towers[_pos]
	return null


func is_building_mode() -> bool:
	return _cursor.mode == _cursor.Mode.BUILD


func _get_new_tower_from_database(tower_name: String) -> TowerBase:
	return Database.get_towers_lib().get_node(tower_name)
