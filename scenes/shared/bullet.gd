extends Sprite2D

var speed:float = 50


func _physics_process(delta: float) -> void:
	global_position += -global_transform.y * speed * delta
