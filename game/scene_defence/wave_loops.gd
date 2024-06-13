class_name WaveLoops

signal wave_started(wave: int)
signal wave_finished(wave: int)


var currect_wave: int = 0


func start_wave(wave := currect_wave):
	currect_wave = wave + 1 
	emit_signal("wave_started", currect_wave)


func finish_wave():
	emit_signal("wave_finished", currect_wave)
