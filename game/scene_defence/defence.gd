extends Node2D


@export var level_packed: PackedScene


var level: Level
var waves := WaveLoops.new()


var _logger := GodotLogger.with("DefenceScene")


@onready var tower_information_panel: PanelContainer = $UI/MarginContainer/TowerInformation


func _ready():
	install_level()
	
	if not level: return
	var enemy_keeper := level.get_enemy_keeper() as EnemiesKeeper
	waves.wave_started.connect(enemy_keeper.generate_wave)
	enemy_keeper.path_cleared.connect(waves.start_wave)
	
	_logger.info("Ready! Game Strted!", {}, Color.GREEN)
	GodotLogger.info("")
	#start game
	waves.call_deferred("start_wave")


func install_level(_level_packed: PackedScene = level_packed):
	if level:
		remove_child(level)
		level.queue_free()
	
	if not _level_packed: return
	level = _level_packed.instantiate()
	add_child(level)
	move_child(level, 0)
	tower_information_panel.towers_builder = level.get_tower_builder()

