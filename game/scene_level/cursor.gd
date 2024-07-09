class_name HalographicCursor
extends Node2D


enum Mode{NONE = 0, BUILD = 1, DEMOLITION = -1}
var mode := Mode.NONE: set = change_mode

var level_size: Vector2i = Vector2i.ONE * 4
var cell_size: int = ProjectSettings.get_setting("game/level/cell/size", 64)
var structure_size: int = 1

var color := Color.WHITE
var place_cheker : BusyPlaceChecker

var select_tower := ""

var _last_cell := Vector2i.ZERO
var _motion_delay := 0.0
var mouse_motion := false
var builder: TowerBuilder


func _ready() -> void:
	top_level = true
	builder = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion = true
	
	elif Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
		mouse_motion = false


func _physics_process(delta: float) -> void:
	if mouse_motion:
		_mouse_follow()
		return
	_key_motion(delta)


func _key_motion(delta):
	var motion := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not motion:
		_motion_delay = 0.05
		return
	
	_motion_delay -= delta
	if _motion_delay > 0: return
	
	_last_cell += Vector2i(motion)
	_last_cell = _last_cell.clamp(Vector2i.ZERO, level_size - Vector2i.ONE)
	_motion_delay = 0.025 if Input.is_action_pressed("cursor_boost") else 0.15
	position = _last_cell * cell_size
	queue_redraw()


func _mouse_follow():
	var cell_position : Vector2i = (get_global_mouse_position() / cell_size).floor()
	if _last_cell != cell_position:
		_last_cell = cell_position
		position = cell_position * cell_size
		queue_redraw()


func _draw() -> void:
	if mode == Mode.NONE:
		color = Color.LIGHT_BLUE
	
	elif can_build():
		color = Color.GREEN
	
	else:
		color = Color.RED
	
	color.a = 0.75
	draw_rect(Rect2(Vector2.ZERO, Vector2.ONE * cell_size), color)
	
	if builder: _draw_range()


func _draw_range():
	var tower: TowerBase = builder.get_tower_below_cursor()
	if not tower:
		if select_tower == "": return 
		tower = Database.get_towers_lib().get_node(select_tower)
		if not tower: return
	
	var radius = (tower.get_stats().vision_range + 0.5) * cell_size 
	var pos = Vector2.ONE * (cell_size / 2.0)
	draw_circle(pos, radius, color * Color(1, 1, 1, 0.4))
	draw_arc(pos, radius, 0, 360, 45, color * Color(1, 1, 1, 0.75), 4)


func change_mode(new_mode: Mode):
	mode = new_mode
	queue_redraw()
	get_parent()._logger.info("change mode on %s" % [Mode.keys()[mode]])


func set_level_size(value):
	level_size = value
	_last_cell = level_size / 2
	position = _last_cell * cell_size


func can_build() -> bool:
	return place_cheker.is_free_place(_last_cell)


func get_center_position():
	return position + Vector2.ONE * (cell_size / 2.0)


func get_cell_position():
	return _last_cell
