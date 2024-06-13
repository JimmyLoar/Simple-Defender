extends Node2D


@export var level_packed: PackedScene
var level: Level
var waves := WaveLoops.new()

func _ready():
	if level_packed:
		level = level_packed.instantiate()
		add_child(level)
		move_child(level, 0)
	


