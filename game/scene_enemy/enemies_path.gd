class_name EnemiesPath
extends Path2D

@export var test_enemy_scene : PackedScene

var cooldown := 0.5

var _pool := []
var _timer := Timer.new()
var _queue_request := []

var _logger := GodotLogger.with("EnemiesPath")

func _init():
	add_child(_timer)
	_timer.one_shot = true
	_timer.wait_time = cooldown
	_timer.timeout.connect(_do_spawn_request)


func spawn(enemy_name: StringName = '',):
	if _timer.is_stopped():
		var enemy := _create_enemy()
		var follower := EnemyPathFollower.new(enemy)
		add_child(follower)
		_logger.debug("spawn new enemy (%s)" % enemy)
		_timer.start()
		return
	
	_queue_request.append(enemy_name)


func spawn_any(count: int):
	for _i in count: spawn()


func _do_spawn_request():
	if _queue_request.is_empty(): return
	var request = _queue_request.pop_front()
	spawn(request)


func _create_enemy() -> Enemy:
	if _pool.is_empty():
		var new: Enemy = preload("res://game/scene_enemy/enemy.tscn").instantiate()
		new.finished.connect(_on_dissapear_enemy)
		new.dead.connect(_on_dissapear_enemy)
		return new
	
	return _pool.pop_front()


func _on_dissapear_enemy(enemy: Enemy):
	var follower := enemy.get_parent()
	remove_child(follower)
	_pool.append(enemy)
	follower.remove_child(enemy)
	follower._enemy = null


class EnemyPathFollower:
	extends PathFollow2D
	
	var _enemy : Enemy
	
	
	func _init(enemy: Enemy):
		rotates = false
		loop = false
		
		_enemy = enemy
		add_child(_enemy)
	
	
	func _physics_process(delta):
		if not _enemy: return
		progress += delta * _enemy.move_speed
		if progress_ratio >= 1:
			get_parent()._logger.debug("enemy %s finished" % _enemy)
			_enemy.emit_signal("finished", _enemy)
