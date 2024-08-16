@tool
extends PanelContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Extends/Label



func set_title(_name: String):
	label.text = _name


func set_icon(icon: Texture):
	texture_rect.texture = icon
