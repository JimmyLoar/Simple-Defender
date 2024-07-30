#@tool
class_name AttackTower
extends TowerBase

@export var weapon_packed: PackedScene
var weapon : TowerWeapon


func _ready() -> void:
	new_stats = DataLibOrigins.new(base_stats)
	_init_weapon()


func _init_weapon():
	weapon_packed = get_stats().weapon
	weapon = weapon_packed.instantiate()
	add_child(weapon)
	radar.targets_changed.connect(weapon._find_target)
	radar.set_vition_range(get_stats().vision_range)
	weapon.radar = radar
	weapon.tower = self
	_logger.debug("loaded weapon %s" % [weapon.name])


func change_weapon(weapon_scene: PackedScene):
	pass


func _get_stats():
	return {
		projectile = preload('res://game/scene_tower/projectiles/!projectile.tscn'),
		weapon = preload('res://game/scene_tower/weapons/weapon_projectile.tscn'),
	}
