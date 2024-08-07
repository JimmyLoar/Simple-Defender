class_name Level
extends Node2D

@export var size := Vector2i(32, 18)

var _place_cheker : BusyPlaceChecker
var _logger := GodotLogger.with("Level")


func _ready():
	_place_cheker = BusyPlaceChecker.new()
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(0))
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(1))
	_place_cheker.add_busy_array(get_tile_map().get_used_cells(2))
	get_tower_builder().place_cheker = _place_cheker
	get_tower_builder().init_cursor()
	_logger.info("Ready!")


func set_currency(new_currency: CurrencySystem):
	get_tower_builder().currency = new_currency
	get_enemy_keeper().currency = new_currency


func get_tile_map() -> TileMap: return %TileMap
func get_tower_builder() -> TowerBuilder: return %Builder
func get_enemy_keeper() -> EnemiesKeeper: return %EnemiesKeeper


