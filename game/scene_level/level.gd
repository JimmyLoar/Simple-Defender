extends Node2D


var astar := AStarGrid2D.new()
var logger := GodotLogger.with("Level")

@onready var tile_map = $TileMap


func update_astar_cells():
	astar.cell_size = Vector2i.ONE * 128
	astar.region = Rect2i(0, 0, 64, 64)
	astar.update()
	_update_astar_solid_tiles()


func _ready():
	update_astar_cells()
	logger.info("ready!")
	var points = astar.get_point_path(Vector2i(3,2), Vector2i(24,14))
	logger.debug(str(points))


func _update_astar_solid_tiles():
	astar.fill_solid_region(astar.region)
	var cells: Array[Vector2i] = tile_map.get_used_cells(0)
	for point in cells:
		astar.set_point_solid(point, false)
	
	
