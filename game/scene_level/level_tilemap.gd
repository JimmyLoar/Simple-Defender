extends TileMap


@export var portal_positions: Array[Vector2i] = [Vector2i.ZERO]:
	set(value):
		portal_positions = value
		_update_object_map()

@export var base_positions: Array[Vector2i] = [Vector2i.ONE]:
	set(value):
		base_positions = value
		_update_object_map()

@export var tile_source_id := {
	"base": 1,
	"portal": 6,
	"possible_base": 2,
}

var astar := AStarGrid2D.new()
var base_position_index := -1:
	set(value):
		base_position_index = value
		_update_object_map()

var _logger := GodotLogger.with("Level.TileMap")

func _ready():
	update()


func update():
	_update_astar_cells()
	_update_astar_solid_tiles()
	_update_object_map()
	_logger.info("updated")


func get_base_point() -> Vector2i:
	return base_positions[base_position_index]


func _update_astar_cells():
	var cell_size = ProjectSettings.get_setting("game/level/cell/size")
	astar.cell_size = Vector2i.ONE * cell_size
	astar.region = Rect2i(0, 0, 64, 64)
	astar.update()
	_logger.debug("update astar region")


func _update_astar_solid_tiles():
	astar.fill_solid_region(astar.region)
	var cells: Array[Vector2i] = get_used_cells(0)
	for point in cells:
		astar.set_point_solid(point, false)
	
	for pos in portal_positions:
		astar.set_point_solid(pos, false)
	
	if base_position_index == -1: _select_base_position()
	astar.set_point_solid(get_base_point(), false)
	_logger.debug("update astar solid cells")


func _select_base_position():
	while true:
		base_position_index = randi_range(0, base_positions.size() - 1)
		if not portal_positions.has(get_base_point()): break
		base_positions.remove_at(base_position_index)
	_logger.debug("selected new base index %s" % [base_position_index])


func _update_object_map():
	clear_layer(1)
	for pos in portal_positions:
		set_cell(1, pos, tile_source_id.portal, Vector2i.ZERO)
	
	for pos in base_positions:
		set_cell(1, pos, tile_source_id.possible_base, Vector2i.ZERO, 1)
	
	set_cell(1, get_base_point(), tile_source_id.base, Vector2i.ZERO)
	_logger.debug("update objects on map")
