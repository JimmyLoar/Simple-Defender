class_name EnemiesPath
extends Path2D

@export var test_enemy_scene : PackedScene

var _logger := GodotLogger.with("EnemiesPath")

var _pool := []


func _ready():
	spawn()


func spawn(enemy_name: StringName = ''):
	var enemy := _create_enemy()
	var follower := EnemyPathFollower.new(enemy)
	add_child(follower)
	_logger.debug("spawn new enemy (%s)" % enemy)
	#breakpoint


func _create_enemy() -> Enemy:
	if _pool.is_empty():
		var new: Enemy = preload("res://game/scene_enemy/enemy.tscn").instantiate()
		return new
	
	return _pool.pop_front()


func _on_death_enemy(enemy: Enemy):
	remove_child(enemy.get_parent())
	_pool.append(enemy)


class EnemyPathFollower:
	extends PathFollow2D
	
	var _enemy : Enemy
	
	
	func _init(enemy: Enemy):
		rotates = false
		loop = false
		
		_enemy = enemy
		add_child(_enemy)
		_enemy.dead.connect(_on_death, CONNECT_ONE_SHOT)
	
	
	func _on_death(enemy: Enemy):
		remove_child(enemy)
	
	
	func _process(delta):
		progress += delta * _enemy.move_speed
