extends Node2D

@onready var camera = $Camera2D  # Adjust the path to your camera
var boid = preload("res://boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pass
	spawn_random(150)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_random(num_instances: int):
	for i in range(num_instances):
		var instance = boid.instantiate()
		add_child(instance)
		var random_x = randf_range(-2100, 2100)
		var random_y = randf_range(-1200, 1200)
		instance.position = Vector2(random_x, random_y)
		instance.rotation = randf_range(-360, 360)

		# instance.dir = Vector2(randf_range(100, 100)/100, randf_range(100, 100)/100)
