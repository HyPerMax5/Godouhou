extends Node2D

@onready var bg = $ParallaxBackground
var direction:Vector2 = Vector2(0, 1)
var bg_speed:float = 45


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	bg.get_child(0).motion_offset.y += bg_speed * delta
	pass
