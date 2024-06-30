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
		_cursor.select_tower = "gun_main"
		return
	
	elif event.is_action_released('buuild_tower_1') and _mode == Mode.BUILD:
		change_mode(Mode.NONE)
	
	
	if event.is_action_pressed('mouse_lclick') and _mode == Mode.BUILD:
		if place_cheker.is_free_place(_cursor.get_cell_position()):
			build_tower(_cursor.select_tower)


func build_tower(tower_name: String):
	place_cheker.add_busy_place(_cursor.get_cell_position())
	var tower = _get_tower(tower_name)
	tower.position = _cursor.get_center_position()
	add_child(tower)
	_logger.info("builded tower %s" % tower.tower_name)


func change_tower(old: TowerBase, new: TowerBase):
	remove_child(old)
	new.position = old.position
	add_child(new)


func _get_tower(tower_name: String) -> TowerBase:
	return Database.get_towers_lib().get_node(tower_name)


class HalographicCursor:
	extends Node2D
	
	var cell_size: int = ProjectSettings.get_setting("game/level/cell/size", 64)
	var color := Color.WHITE
	var _enable := true
	var place_cheker : BusyPlaceChecker
	
	var select_tower := ""
	
	var _last_cell := Vector2i.ZERO
	var _velocity := Vector2i() 
	var _offset_delay := 0.0
	var _motion := Vector2i.ZERO
	
	
	func set_enable(value: bool, _tower: String = ""):
		_enable = value
		visible = value
		#select_tower = _tower
	
	
	func _ready() -> void:
		top_level = true
	
	
	func _input(event: InputEvent) -> void:
		_velocity = Vector2i.ZERO
		if event.is_action_released("ui_left"):
			_velocity.x -= 1
		if event.is_action_released("ui_right"):
			_velocity.x += 1
		if event.is_action_released("ui_up"):
			_velocity.y -= 1
		if event.is_action_released("ui_down"):
			_velocity.y += 1
	
	
	func _physics_process(delta: float) -> void:
		_offset_delay -= delta
		if _offset_delay > 0.0: 
			return
		
		_velocity = (_velocity + _get_input_direction()).clamp(Vector2i.ONE * -1, Vector2i.ONE)
		_last_cell = (_last_cell + _velocity).clamp(Vector2.ZERO, Vector2(31, 17))
		position = _last_cell * cell_size
		_offset_delay = 0.025 if Input.is_action_pressed("cursor_boost") else 0.25
		queue_redraw()
		_velocity = Vector2i.ZERO
	
	
	func _get_input_direction() -> Vector2i:
		if _velocity != Vector2i.ZERO: return Vector2i.ZERO
		var dir: Vector2i = Vector2i()
		dir.x = Input.get_axis("ui_left", "ui_right")
		dir.y = Input.get_axis("ui_up", "ui_down")
		return dir
	
	
	func _mouse_follow():
		var cell_position : Vector2i = (get_global_mouse_position() / cell_size).floor()
		if _last_cell != cell_position:
			_last_cell = cell_position
			position = cell_position * cell_size
			queue_redraw()
	
	
	func _draw() -> void:
		if can_build():
			color = Color.GREEN
		
		else:
			color = Color.RED
		
		color.a = 0.75
		draw_rect(Rect2(Vector2.ZERO, Vector2.ONE * cell_size), color)
 	
	
	func can_build() -> bool:
		return place_cheker.is_free_place(_last_cell)
	
	
	func get_center_position():
		return position + Vector2.ONE * (cell_size / 2.0)
	
	
	func get_cell_position():
		return _last_cell
