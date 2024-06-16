class_name HitpointsCompanent
extends TextureProgressBar

signal death

var _logger : Log

func _init(_max):
	max_value = _max
	name = "HpBar"
	reset()


func _ready():
	var texture := ShapeTexture2D.new()
	texture.shape = DrawableRectangle.new()
	texture.size = Vector2i(48, 4)
	
	texture_under = texture
	texture_progress = texture
	
	position = Vector2(-24, 20)
	
	tint_progress = Color("27ff2f")
	tint_under = Color("000000b8")


func reset():
	value = max_value


func take_damage(damage: int):
	value -= damage
	_logger.debug("take %d damage" % damage)
	if is_dead(): 
		_logger.debug("DEAD!")
		death.emit()


func is_dead() -> bool:
	return value <= 0.0




