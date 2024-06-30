extends PanelContainer

@export var data_name := "gun_main"

var data_lib : DataLib = Database.get_towers_lib()


var _tower : TowerBase 

func _ready() -> void:
	_tower = data_lib.get_node(data_name)
	update(_tower)


func update(tower: TowerBase):
	if not tower: return
	update_name(tower.tower_name)
	


func update_name(new_name: String):
	$VBoxContainer/Label.text = new_name
