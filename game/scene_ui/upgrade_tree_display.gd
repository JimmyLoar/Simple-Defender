extends PanelContainer

@export var test_tree: PackedScene

var tree_list := Dictionary()

@onready var viewport: SubViewport = $SubViewportContainer/Viewport

func _ready() -> void:
	init_tree_list()


func init_tree_list():
	for tree in viewport.get_children():
		if not tree is TreeDisplay: continue
		tree_list[tree.tree_name] = tree
		tree.hide()


func set_tower(tower: TowerBase):
	for key in tree_list.keys():
		var tree: TreeDisplay = tree_list[key]
		tree.visible = key == tower.tree_name
		if tree.visible:
			tree.set_tower(tower)


func set_currency(currency: CurrencySystem):
	for tree in viewport.get_children():
		if not tree is TreeDisplay: continue
		tree.currency = currency
