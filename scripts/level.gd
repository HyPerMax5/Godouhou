extends Node2D

@onready var bg = $ParallaxBackground
var direction:Vector2 = Vector2(0, 1)
var bg_speed:float = 45


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#bg.scroll_offset.y +=  speed * delta
	bg.get_child(0).motion_offset.y += bg_speed * delta
	pass
