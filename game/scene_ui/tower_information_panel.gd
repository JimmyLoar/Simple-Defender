extends PanelContainer

signal sell_pressed
signal upgrade_pressed


@export var data_name := "gun_main"


var data_lib : DataLib = Database.get_towers_lib()
var towers_builder: TowerBuilder

var _tower : TowerBase 
var _logger := GodotLogger.with("%s" % self)


@onready var stat_container: GridContainer = $VBoxContainer/StatContainer
@onready var _synh : ChildSynhronizer 


func _ready() -> void:
	_synh = ChildDictionarySynhronizer.new(stat_container, $VBoxContainer/StatContainer/StatDisplay, "_update")
	_tower = data_lib.get_node(data_name)
	#update(_tower)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_select"):
		if towers_builder.is_building_mode(): 
			hide()
			return
		update(towers_builder.get_tower_below_cursor())
	
	elif event.is_action_released("ui_close"):
		hide()


func update(tower: TowerBase):
	if not tower: 
		hide()
		return
	
	if not visible: show()
	update_name(tower.tower_name)
	_synh.synhonize(tower.get_stats())
	_logger.debug("updated %s" % tower)


func update_name(new_name: String):
	%TitleLabel.text = new_name


func _on_button_pressed() -> void:
	upgrade_pressed.emit()
