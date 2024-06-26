extends Node2D


@export var level_packed: PackedScene
var level: Level
var waves := WaveLoops.new()
var _logger := GodotLogger.with("DefenceScene")


func _ready():
	if level_packed:
		level = level_packed.instantiate()
		add_child(level)
		move_child(level, 0)
	
	if not level: return
	var enemy_keeper := level.get_enemy_keeper() as EnemiesKeeper
	waves.wave_started.connect(enemy_keeper.generate_wave)
	enemy_keeper.path_cleared.connect(waves.start_wave)
	
	_logger.info("Ready! Game Strted!", {}, Color.GREEN)
	GodotLogger.info("")
	#start game
	waves.call_deferred("start_wave")


