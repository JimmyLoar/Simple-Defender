class_name TowerBuilder
extends Node2D


@export var place_cheker: BusyPlaceChecker


var _cursor := HalographicCursor.new()
var _logger := GodotLogger.with("Builder")

var _builed_towers: Dictionary = {}


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
	var key = _check_on_build_pressed(event)
	if key != "":
		if not is_building_mode():
			_cursor.change_mode(_cursor.Mode.BUILD)
			_cursor.select_tower = BUILD_PRESSED[key]
			return
		
		elif is_building_mode():
			_cursor.select_tower = ""
			_cursor.change_mode(_cursor.Mode.NONE)
	
	
	if (event.is_action_pressed('ui_select') or event.is_action("mouse_lclick"))\
		and is_building_mode():
		if place_cheker.is_free_place(_cursor.get_cell_position()):
			build_tower(_cursor.select_tower)
			_cursor.queue_redraw()


func _check_on_build_pressed(event):
	for key in BUILD_PRESSED.keys():
		if event.is_action_released(key):
			return key
	
	return ""


func switch_tower(tower_name: String, cell_position: Vector2):
	pass


func build_tower(tower_name: String):
	place_cheker.add_busy_place(_cursor.get_cell_position())
	var tower = _get_tower(tower_name)
	tower.position = _cursor.get_center_position()
	add_child(tower)
	_builed_towers[_cursor.get_cell_position()] = tower
	_logger.info("builded tower %s for %s" % [tower.tower_name, _cursor.get_cell_position()])


func remove_tower(cell_position: Vector2i):
	if not _builed_towers.has(cell_position): return
	_builed_towers.erase(cell_position)


func change_tower(old: TowerBase, new: TowerBase):
	remove_child(old)
	new.position = old.position
	add_child(new)


func get_tower_below_cursor():
	var _pos = _cursor.get_cell_position()
	if _builed_towers.has(_pos):
		return _builed_towers[_pos]
	return null


func is_building_mode() -> bool:
	return _cursor.mode == _cursor.Mode.BUILD


func _get_tower(tower_name: String) -> TowerBase:
	return Database.get_towers_lib().get_node(tower_name)



