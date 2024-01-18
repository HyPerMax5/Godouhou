extends Path2D


var speed:int = 100000
@onready var follow:PathFollow2D = $PathFollow2D

func _process(delta: float) -> void:
	follow.progress += delta * speed / curve.get_baked_length()
