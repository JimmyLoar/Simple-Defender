extends PanelContainer


@export var data_name := "gun_main"


var data_lib : DataLib = Database.get_towers_lib()


var _tower : TowerBase 


@onready var stat_container: GridContainer = $VBoxContainer/StatContainer
@onready var _synh : ChildSynhronizer 


func _ready() -> void:
	_synh = ChildDictionarySynhronizer.new(stat_container, $VBoxContainer/StatContainer/StatDisplay, "_update")
	_tower = data_lib.get_node(data_name)
	update(_tower)
	


func update(tower: TowerBase):
	if not tower: return
	update_name(tower.tower_name)
	_synh.synhonize(tower.get_stats())


func update_name(new_name: String):
	%TitleLabel.text = new_name
