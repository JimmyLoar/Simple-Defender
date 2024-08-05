#@tool
class_name AttackTower
extends TowerBase

@export var weapon_packed: PackedScene
var weapon : TowerWeapon


func _ready() -> void:
	base_stats["weapon"] = preload('res://game/scene_tower/weapons/weapon_projectile.tscn')
	base_stats["attacker_entity"] = preload('res://game/scene_tower/projectiles/!projectile.tscn')
	change_weapon()


func _update():
	change_weapon()


func change_weapon():
	if weapon:
		remove_weapon()
	
	var scene: PackedScene = get_stats().weapon
	var new_weapon: TowerWeapon = scene.instantiate()
	add_weapon(new_weapon)


func add_weapon(scene: TowerWeapon):
	weapon = scene
	add_child(weapon)
	radar.targets_changed.connect(weapon._find_target)
	radar.set_vition_range(get_stats().vision_range)
	weapon.radar = radar
	weapon.tower = self
	_logger.debug("loaded weapon %s" % [weapon.name])


func remove_weapon():
	if radar.is_connected(weapon._find_target):
		radar.targets_changed.disconnect(weapon._find_target)
	radar.set_vition_range(get_stats().vision_range)
	remove_child(weapon)
	_logger.debug("removed weapon %s" % [weapon.name])


