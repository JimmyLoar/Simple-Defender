@tool
extends Node


var _data := {
	tower = DataLib.new({
		&"gun_main": preload('res://resources/towers/gun/gun_main.tscn'),
		&"gun_a": preload('res://resources/towers/gun/gun_a.tscn'),
		&"gun_b": preload('res://resources/towers/gun/gun_b.tscn'),
		&"gun_c": preload('res://resources/towers/gun/gun_c.tscn'),
	}),
	enemy = DataLib.new({
		
	}),
	level = DataLib.new({
		
	}),
	upgrade_tree = DataLib.new({
		&"gun_t1_v1": preload('res://resources/upgrade_tree/gun_t1_v1.tscn'),
	}),
	
	skills = DataLib.new({
		 &"none" : {
			"name": "NoneSkill",
			"icon": preload('res://icon.svg'),
			#"modulate": Color.WHITE,
			"discription": "",
			"influence_type": TreeNode.InfluenceType.NONE,
			"influence_name": "none",
			"influence_value": "",
		},
		 &"tower_gun" : {
			"name": "Tower Gun",
		},
		&"damage_l1" : {
			"name": "Damage",
			"influence_type": TreeNode.InfluenceType.ADD_TO_PROPERTY,
			"influence_name": "damage",
			"influence_value": "3",
		},
		&"damage_l2" : {
			"name": "Damage +",
			"influence_type": TreeNode.InfluenceType.ADD_TO_PROPERTY,
			"influence_name": "damage",
			"influence_value": "5",
		},
		&"firerate" : {
			"name": "Firerate",
			"influence_type": TreeNode.InfluenceType.ADD_TO_PROPERTY,
			"influence_name": "firerate",
			"influence_value": "2",
		},
		&"range" : {
			"name": "Range",
			"influence_type": TreeNode.InfluenceType.ADD_TO_PROPERTY,
			"influence_name": "vision_range",
			"influence_value": "1.25",
		},
		&"focus" : {
			"name": "Focus",
			"influence_type": TreeNode.InfluenceType.ADD_TO_PROPERTY,
			"influence_name": "vision_range,firerate",
			"influence_value": "0.5,1",
		},
	}),
}


@onready var _logger := GodotLogger.with("Database")

func get_enemy_lib() -> DataLib: return _data.enemy
func get_enemy_keys() -> Array: 
	return get_enemy_lib().get_all_data().keys()

func get_towers_lib()  -> DataLib: return _data.tower
func get_towers_keys() -> Array: 
	return get_towers_lib().get_all_data().keys()

func get_level_lib()   -> DataLib: return _data.level
func get_level_keys() -> Array: 
	return get_level_lib().get_all_data().keys()

func get_upgrade_lib() -> DataLib: return _data.upgrade_tree
func get_upgrade_keys() -> Array: 
	return get_upgrade_lib().get_all_data().keys()

func get_skill_lib() -> DataLib: return _data.skills
func get_skill_keys() -> Array: 
	return get_skill_lib().get_all_data().keys()


func _ready() -> void:
	_logger.info("database has libs '%s'" % _data)


