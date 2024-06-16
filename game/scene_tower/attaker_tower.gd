#@tool
class_name AttackTower
extends TowerBase

@export var weapon_packed: PackedScene
var weapon : TowerWeapon


func _init():
	ready.connect(_init_weapon)


func _init_weapon():
	weapon = weapon_packed.instantiate()
	add_child(weapon)
	radar.targets_changed.connect(weapon._find_target)
	weapon.radar = radar
	_logger.debug("loaded weapon %s" % [weapon.name])


