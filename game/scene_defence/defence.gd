extends Node2D


@export var level_packed: PackedScene


var level: Level
var waves := WaveLoops.new()
var currency: CurrencySystem

var _logger := GodotLogger.with("DefenceScene")


@onready var tower_information_panel: PanelContainer = %TowerInformation


func _ready():
	init_currency()
	install_level()
	
	level.set_currency(currency)
	
	if not level: return
	var enemy_keeper := level.get_enemy_keeper() as EnemiesKeeper
	waves.wave_started.connect(enemy_keeper.generate_wave)
	enemy_keeper.path_cleared.connect(waves.start_wave)
	
	_logger.info("Ready! Game Strted!", {}, Color.GREEN)
	waves.call_deferred("start_wave") #this start game


func install_level(_level_packed: PackedScene = level_packed):
	if level:
		remove_child(level)
		level.queue_free()
	
	if not _level_packed: return
	level = _level_packed.instantiate()
	add_child(level)
	move_child(level, 0)
	tower_information_panel.towers_builder = level.get_tower_builder()


func init_currency():
	currency = CurrencySystem.new()
	currency.value_changed.connect(__temporal__label_update)
	%UpgradeTreePanel.set_currency(currency)
	var icon_placeholder := preload('res://icon.svg')
	currency.create("money", icon_placeholder, 500)
	currency.create("scrap", icon_placeholder)
	currency.create("energy", icon_placeholder, 15, 25)
	__temporal__label_update()


func __temporal__label_update():
	$UI/UpperBar/HBoxContainer/Label.text = "Money: %s" %   [currency.get_value("money")]
	$UI/UpperBar/HBoxContainer/Label2.text = "Energy: %s" % [currency.get_value("energy")]
	$UI/UpperBar/HBoxContainer/Label3.text = "Scrap: %s" %  [currency.get_value("scrap")]
