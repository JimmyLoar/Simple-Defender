class_name TowerBuilder
extends Node2D

@export var place_cheker: BusyPlaceChecker

enum Mode{NONE = 0, BUILD = 1, DEMOLITION = -1}
@export var _mode := Mode.NONE: set = change_mode

var _cursor := HalographicCursor.new()
var _logger := GodotLogger.with("Builder")


func _ready() -> void:
	add_child(_cursor)
	_cursor.place_cheker = place_cheker


func change_mode(new_mode: Mode):
	_mode = new_mode
	_cursor.set_enable(_mode != Mode.NONE)
	_logger.info("change mode on %s" % [Mode.keys()[_mode]])


func _input(event: InputEvent) -> void:
	if event.is_action_released('buuild_tower_1') and _mode != Mode.BUILD:
		change_mode(Mode.BUILD)
		_cursor.select_tower = "gun"
		return
	
	elif event.is_action_released('buuild_tower_1') and _mode == Mode.BUILD:
		change_mode(Mode.NONE)
	
	
	if event.is_action_pressed('mouse_lclick') and _mode == Mode.BUILD:
		if place_cheker.is_free_place(_cursor.get_cell_position()):
			build_tower(_cursor.select_tower)


func build_tower(tower_name: String):
	var tower = _get_tower(tower_name)
	tower.position = _cursor.get_center_position()
	add_child(tower)
	place_cheker.add_busy_place(_cursor.get_cell_position())
	_logger.info("builded tower %s" % tower.tower_name)


func _get_tower(tower_name: String) -> TowerBase:
	var path : String = Database.get_towers_lib().get_data(tower_name)
	if not path: return null
	var _scene : PackedScene = load(path) 
	if not _scene: return null 
	var tower : TowerBase = _scene.instantiate()
	return tower


class HalographicCursor:
	extends Node2D
	
	var cell_size: int = ProjectSettings.get_setting("game/level/cell/size", 64)
	var color := Color.WHITE
	var _enable := true
	var place_cheker : BusyPlaceChecker
	
	var select_tower := ""
	
	var _last_cell := Vector2.ZERO
	
	
	func set_enable(value: bool, _tower: String = ""):
		_enable = value
		visible = value
		#select_tower = _tower
	
	
	func _ready() -> void:
		top_level = true
	
	
	func _process(delta: float) -> void:
		if not _enable: return
		var cell_position : Vector2 = (get_global_mouse_position() / cell_size).floor()
		if _last_cell != cell_position:
			_last_cell = cell_position
			position = cell_position * cell_size
			queue_redraw()
	
	
	func _draw() -> void:
		if place_cheker.is_free_place(_last_cell):
			color = Color.GREEN
		
		else:
			color = Color.RED
		
		color.a = 0.75
		draw_rect(Rect2(Vector2.ZERO, Vector2.ONE * cell_size), color)
 	
	
	func get_center_position():
		return position + Vector2.ONE * (cell_size / 2)
	
	
	func get_cell_position():
		return _last_cell
