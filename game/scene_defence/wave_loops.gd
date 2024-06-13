class_name WaveLoops

signal wave_started(wave: int)
signal wave_finished(wave: int)


var _wave: int = 0
var _logger := GodotLogger.with("WaveLoops")


func start_wave(wave := _wave):
	if wave != wave: _logger.debug("set wave value on %d" % wave)
	_wave = wave + 1 
	_logger.info("started new wave #%d" % _wave)
	emit_signal("wave_started", _wave)


func finish_wave():
	_logger.info("finished new wave #%d" % _wave)
	emit_signal("wave_finished", _wave)


func get_currect_wave():
	return _wave
