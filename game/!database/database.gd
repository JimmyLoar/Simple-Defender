@tool
extends Node


var _data := {
	tower = DataLibPackedScene.new({
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
			"influence_type": [TYPE_FLOAT],
			"influence_key": [],
			"influence_value": [0.0],
		},
		 &"root_gun" : {
			"extends" : &"none",
			"name": "Tower Gun",
		},
		&"damage_l1" : {
			"extends" : &"none",
			"name": "Damage",
			"influence_type": [TYPE_INT],
			"influence_key": ["damage"],
			"influence_value": [3],
		},
		&"damage_l2" : {
			"extends" : &"damage_l1",
			"name": "Damage +",
			"influence_value": [5],
		},
		&"firerate" : {
			"extends" : &"none",
			"name": "Firerate",
			"influence_key": ["firerate"],
			"influence_value": [2.0],
		},
		&"range" : {
			"extends" : &"none",
			"name": "Range",
			"influence_key": ["vision_range"],
			"influence_value": [1.25],
		},
		&"focus" : {
			"extends" : &"none",
			"name": "Focus",
			"influence_type": [TYPE_FLOAT, TYPE_FLOAT],
			"influence_key": ["vision_range", "firerate"],
			"influence_value": [0.5, 1.0],
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
	init_skills()
	_logger.info("database has libs '%s'" % _data)

func init_skills():
	var skills_data := get_skill_lib().get_all_data()
	for key: String in skills_data.keys():
		var skill: Dictionary = skills_data[key]
		var vkey = key
		while skills_data[vkey].has("extends"):
			vkey = skills_data[vkey].extends
			skill.merge(skills_data[vkey])
		
		get_skill_lib().set_for_key(key, skill)
		
		
		
		


