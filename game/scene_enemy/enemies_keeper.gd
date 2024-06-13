class_name EnemiesKeeper
extends Node2D

@export_range(1, 8, 1) var path_count := 1

@export_group("Generation", "_gen_")
@export var _gen_min_count_in_wave := 5
@export var _gen_grow_count_from_wave := 0.1
@export var _gen_max_count_in_wave := 10


func generate_wave(wave: int = 0):
	var enemy_count : int = min(_gen_min_count_in_wave + float(wave * _gen_grow_count_from_wave), _gen_max_count_in_wave)
	get_child(0).spawn_any(enemy_count)


func get_packed_enemy(enemy_name: StringName):
	pass
