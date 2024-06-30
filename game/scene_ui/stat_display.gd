@tool
extends PanelContainer


@export_range(16, 128, 4) var _font_size: int = 16: 
	set = set_font_size
@export_enum("Show All:0", "Hide Texture:1", "Hide Name:2", "Hide All:3") var display_mode = 0:
	set = set_display_mode


@onready var texture: TextureRect = $HBox/Texture
@onready var name_label: Label = $HBox/NameLabel
@onready var separator_label: Control = $HBox/SeparatorLabel
@onready var value_label: Label = $HBox/ValueLabel


func _ready() -> void:

	pass

func set_font_size(value: int):
	_font_size = value
	if not is_inside_tree(): return
	
	$HBox.set('theme_override_constants/separation', _font_size / 4)
	name_label.set('theme_override_font_sizes/font_size', _font_size)
	value_label.set('theme_override_font_sizes/font_size', _font_size)
	texture.set_deferred("custom_minimum_size", Vector2.ONE * (1.5 * _font_size))


func set_display_mode(new_mode: int):
	display_mode = wrapi(new_mode, 0, 4)
	match display_mode:
		0:
			texture.show()
			name_label.show()
		1:
			texture.hide()
			name_label.show()
		2:
			texture.show()
			name_label.hide()
		_:
			texture.hide()
			name_label.hide()
