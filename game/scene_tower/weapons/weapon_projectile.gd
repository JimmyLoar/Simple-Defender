class_name TWeaponProjectile
extends TowerWeapon

@export var projectile_packed: PackedScene
#
@onready var projectile_box = $ProjectileBox
@onready var gunpoint_marker = $Gunpoints/Marker2D

var _pool := []

func _shoot():
	var projectile := _create_projectile()
	projectile.launch(gunpoint_marker.global_transform)
	projectile_box.add_child(projectile)
	_logger.debug("shooting %s" % projectile)


func _create_projectile() -> Projectile:
	if not _pool.is_empty(): return _pool.pop_front()
	var new_projectile : Projectile = projectile_packed.instantiate()
	new_projectile.dissappeared.connect(_remove_projectile.bind(new_projectile), CONNECT_DEFERRED)
	new_projectile.hitted.connect(_on_hitted.bind(new_projectile), CONNECT_DEFERRED)
	return new_projectile


func _remove_projectile(projectile: Node2D):
	if not projectile.get_parent(): return
	projectile_box.remove_child(projectile)
	_pool.append(projectile)


func _on_hitted(enemy: Enemy, projectile: Projectile):
	_logger.debug("projectile %s hitted on %s" % [projectile, enemy])
	enemy.get_hit_points().take_damage(tower.get_stats().damage)

