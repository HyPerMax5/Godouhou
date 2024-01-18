extends Sprite2D


var collision = Stat.collision_dict["Player"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var distance_travelled
var target
var speed:float = 10
var start_position
var shape = CircleShape2D.new()

func _ready() -> void:
	shape.radius = 3
	distance_travelled = 1
	start_position = global_position


func _process(delta: float) -> void:

	var query := PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.collision_mask = collision
	query.transform = global_transform
	query.collide_with_areas = true
	var result := get_world_2d().direct_space_state.intersect_shape(query, 1)
	#print(target)
	if target == null:
		var distance = speed * delta
		var motion = global_transform.y * speed * delta
		#var motion := -global_transform.y * speed * delta
		global_position += motion
		distance_travelled += distance
	
	for hit in result:
		if hit.collider.is_in_group("Player"):
			print("test")
			hit.collider.on_collected(self)
			queue_free()
		#if hit.collider.is_in_group("Player Collection"):
			#target = hit.collider.owner
			#var distance_to_target := global_position.distance_to(target.global_position)
			#if distance_to_target >= 2:
				#global_position = global_position.lerp(target.global_position, speed/3 * delta)
			#if distance_to_target < 0.5:
				#global_position = global_position.lerp(target.global_position, speed/3 * delta)
				#target = null


	if distance_travelled > 1200:
		queue_free()
