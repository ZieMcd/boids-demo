extends Node2D


@onready var vision = $Vision
@onready var this_id = get_instance_id()
@onready var near_by_boids:Dictionary = {}

@export var speed = 400
@export var debug = false
@export var dir = Vector2(1, 1)
@export var dis_between = 240


func _ready() -> void:
	vision.area_entered.connect(_enter)
	vision.area_exited.connect(_leave)

func _process(delta: float) -> void:
	dir = Center().normalized()
	dir = Aligne().normalized()
	dir = Avoid().normalized()
	rotation =  dir.angle_to_point(Vector2.ZERO)
	position += dir * speed * delta


func Center():
	var sum_pos = Vector2.ZERO
	var num_boids = near_by_boids.size()

	if num_boids < 1:
		return dir

	for boid_id in near_by_boids:
		sum_pos += near_by_boids[boid_id].global_position
	
	var avg_pos = sum_pos/num_boids
	
	return dir + ((avg_pos - global_position).normalized())/2

func Aligne():
	var sum_dir = dir
	var num_boids = near_by_boids.size()

	if num_boids < 1:
		return dir

	for boid_id in near_by_boids:
		sum_dir += near_by_boids[boid_id].dir
	
	var avg_dir = sum_dir/num_boids

	if(debug):
		prints("avg dir: ", avg_dir, "my dir: ", dir)

	return dir + avg_dir/2
	
func Avoid():
	var result = Vector2.ZERO
	if (near_by_boids.size() == 0):
		return dir

	if debug:
		prints("num boids: ", near_by_boids.size())

	for body_id in near_by_boids:
		var boid = near_by_boids[body_id]
		var new_dir = (global_position - boid.global_position).normalized()

		var force_strength = 1 - clamp(((global_position - boid.global_position).length()/dis_between), 0, 1)

		result += (new_dir*force_strength)

		if debug:
			prints("dir: ", dir, " new dir: ", new_dir)
			# prints("dir: ", dir, " new dir: ", new_dir)
			prints("mang: ", (global_position - boid.global_position).length())
			prints("force_strength: ", force_strength)
			prints("new dir: ", dir + result)

		return dir + result

func _enter(body: Node2D):
	
	if body.name == 'Body':
		var parent = body.get_parent()
		var body_id = parent.get_instance_id()
		if body_id != this_id:
			near_by_boids[body_id] = parent
		
	

func _leave(body: Node2D):
	var parent = body.get_parent()
	var body_id = parent.get_instance_id()
	near_by_boids.erase(body_id)
