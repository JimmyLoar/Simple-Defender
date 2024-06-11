extends TileMap


@export var portal_positions: Array[Vector2i] = [Vector2i.ZERO]
@export var base_positions: Array[Vector2i] = [Vector2i.ONE]

@export var tile_source_id := {
	"base": 1,
	"portal": 6,
}

var astar := AStarGrid2D.new()
var base_position_index := -1


func _ready():
	_update_astar_cells()


func update():
	_update_astar_cells()
	_update_astar_solid_tiles()
	_update_object_map()


func get_base_position() -> Vector2i:
	return base_positions[base_position_index]


func _update_astar_cells():
	astar.cell_size = Vector2i.ONE * 128
	astar.region = Rect2i(0, 0, 64, 64)
	astar.update()


func _update_astar_solid_tiles():
	astar.fill_solid_region(astar.region)
	var cells: Array[Vector2i] = get_used_cells(0)
	for point in cells:
		astar.set_point_solid(point, false)
	
	for pos in portal_positions:
		astar.set_point_solid(pos, false)
	
	if base_position_index == -1: _select_base_position()
	astar.set_point_solid(get_base_position(), false)
	_update_object_map()


func _select_base_position():
	while true:
		base_position_index = randi_range(0, base_positions.size() - 1)
		if not portal_positions.has(get_base_position()): break
		base_positions.remove_at(base_position_index)


func _update_object_map():
	clear_layer(1)
	for pos in portal_positions:
		set_cell(1, pos, tile_source_id.portal)
	
	set_cell(1, get_base_position(), tile_source_id.base)
