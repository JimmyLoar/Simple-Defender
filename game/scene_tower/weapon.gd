class_name TowerWeapon
extends Node2D

#@export var base_damage := 1
#@export var base_recharge := 0.35


var main_target : Node2D
var targets: Array[Node2D] = []
var radar : TowerRadarCompanent
var recharger := Timer.new()
var tower : TowerBase

@onready var _logger: Log = GodotLogger.with("%s.%s" % [get_parent(), self.name])

var _ready_to_shoot := true


func _init():
	add_child(recharger)
	recharger.timeout.connect(_on_recharged)


func _target_chenged(_radar: TowerRadarCompanent):
	if not _radar: return
	radar = _radar
	targets = radar.get_target()
	main_target = targets.front()


func _physics_process(delta):
	if main_target:
		look_at(main_target.global_position)
		if not _ready_to_shoot: return 
		_ready_to_shoot = false
		recharger.start(1 / tower.get_stats().firerate)
		_shoot()
	
	else:
		_find_target()
	


func _find_target():
	if not radar: return
	main_target = radar.get_first_target_or_null()


func _shoot():
	_logger.debug("shoting")


func _on_recharged():
	_ready_to_shoot = true
