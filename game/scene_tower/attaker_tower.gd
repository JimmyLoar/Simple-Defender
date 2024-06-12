#@tool
class_name AttackTower
extends TowerBase

@export var weapon_packed: PackedScene
var weapon : TowerWeapon


func _ready():
	weapon = weapon_packed.instantiate()
	add_child(weapon)
	radar.targets_changed.connect(weapon._target_chenged.bind(radar))
	_logger.debug("loaded weapon %s" % [weapon.name])


