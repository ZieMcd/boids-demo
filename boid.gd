extends Node2D


@onready var vision = $Vision
@onready var this_id = get_instance_id()
@onready var near_by_boids:Dictionary = {}

@export var speed = 400
@export var turn_multipler = 50
@export var debug = false
@export var dir = Vector2(1, 1)


func _ready() -> void:
	vision.area_entered.connect(_enter)
	vision.area_exited.connect(_leave)

func _process(delta: float) -> void:
	dir = Avoid2()
	rotation =  dir.angle_to_point(Vector2.ZERO)
	position += dir * speed * delta


# func Aligne():
# 	var sum_dir = Vector2.ZERO
# 	var num_boids = near_by_boids.size()
# 	prints("num: ",num_boids)
# 	if num_boids < 1:
# 		return Vector2.ZERO

# 	for boid_id in near_by_boids:
# 		prints(near_by_boids[boid_id].dir)
# 		sum_dir += near_by_boids[boid_id].dir
# 	
# 	var avg_dir = sum_dir/num_boids
# 	prints("avg dir: ", avg_dir, "my dir: ", dir.normalized())
# 	return avg_dir.normalized()
	
func Avoid2():
	if (near_by_boids.size() == 0):
		return dir

	if debug:
		prints("num boids: ", near_by_boids.size())

	for body_id in near_by_boids:
		var boid = near_by_boids[body_id]
		var new_dir = (global_position - boid.global_position).normalized()

		var force_strength = 1 - clamp(((global_position - boid.global_position).length()/240), 0, 1)

		if debug:
			prints("dir: ", dir, " new dir: ", new_dir)
			# prints("dir: ", dir, " new dir: ", new_dir)
			prints("mang: ", (global_position - boid.global_position).length())
			prints("force_strength: ", force_strength)


		return dir.normalized() + new_dir*force_strength


 # from https://www.youtube.com/watch?v=oFnIlNW_p10&list=WL&index=2&t=966s
func Avoid(cur_dir: Vector2):
	var relative_pos_sum = Vector2.ZERO

	for body_id in near_by_boids:
		var body = near_by_boids[body_id]
		relative_pos_sum += position - body.position
		
	if relative_pos_sum != Vector2.ZERO:
		return relative_pos_sum/Vector2(pow(relative_pos_sum.x, 2), pow(relative_pos_sum.y, 2))

	return cur_dir



@export var speed_old = 100
@export var rotational = 0.01
@export var turn_force = 35
func MyMethodForAviodance(delta: float):

	for body_id in near_by_boids:
		var body = near_by_boids[body_id]
		var other_local_pos = to_local(body.position)
		var distance = sqrt(abs(other_local_pos.x)) + sqrt(abs(other_local_pos.y))

		var f = (turn_force - distance) * rotational

		if f < 0:
			f = 0

		if other_local_pos.x < 0:
			rotation = (rotation + f)
		else:
			rotation = (rotation - f)

	position -= Vector2(speed_old, 0).rotated(rotation) * delta


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
