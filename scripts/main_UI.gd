extends Control



func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	var fps := Engine.get_frames_per_second()
	var delta_display := delta*10000
	delta_display = snapped(delta_display, 0.1)
	%FPS.text = str(fps) + " fps"
	%Delta.text = str(delta_display) + " delta"
	pass
