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
	_update_vition_mode()
	_update_font_size()


func _update(text: String, value):
	name_label.text = text.capitalize().rpad(16)
	var value_text: String
	match typeof(value):
		TYPE_FLOAT: value_text = "%0.2f" % value
		TYPE_INT: value_text = "%d" % value
		_: value_text = "%s" % value
	value_label.text = value_text.lpad(3)


func set_font_size(value: int):
	_font_size = value
	if not is_inside_tree(): return
	_update_font_size()


func _update_font_size():
	$HBox.set('theme_override_constants/separation', _font_size / 4.0)
	name_label.set('theme_override_font_sizes/font_size', _font_size)
	value_label.set('theme_override_font_sizes/font_size', _font_size)
	texture.set_deferred("custom_minimum_size", Vector2.ONE * (1.5 * _font_size))


func set_display_mode(new_mode: int):
	display_mode = wrapi(new_mode, 0, 4)
	if not is_inside_tree(): return
	_update_vition_mode()


func _update_vition_mode():
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
