extends Node2D

@onready var camera = $Camera2D  # Adjust the path to your camera
@onready var view_port = get_viewport_rect()
@onready var left = -2877
@onready var right = 2877
@onready var top = -1600
@onready var bottom = 1600
@onready var boids = []
@export var num_instances = 150
var boid_asset = preload("res://boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_random()
	prints(view_port)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	for boid in boids:
		if boid.position.x > right:
			boid.position.x = left 
		if boid.position.x < left:
			boid.position.x = right
		if boid.position.y > bottom:
			boid.position.y = top
		if boid.position.y < top:
			boid.position.y = bottom

func spawn_random():
	for i in range(num_instances):
		var instance = boid_asset.instantiate()
		add_child(instance)
		var random_x = randf_range(-2100, 2100)
		var random_y = randf_range(-1200, 1200)
		instance.position = Vector2(random_x, random_y)
		instance.dir = Vector2(randf_range(-100, 100)/100, randf_range(-100, 100)/100)
		boids.append(instance)
