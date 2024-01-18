extends PathFollow2D

var speed = 100

func _physics_process(delta):
	progress += delta * speed / curve.get_baked_length()
