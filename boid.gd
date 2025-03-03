extends Node2D


@onready var vision = $Vision
@onready var this_id = get_instance_id()
@onready var near_by_boids:Dictionary = {}

# var top = 1200*2
# var bottom = -top
# var left = 2100*2
# var right = -left

@export var speed = 100
@export var debug = false
@export var dir = Vector2(1, 1)

func _ready() -> void:
	vision.area_entered.connect(_enter)
	vision.area_exited.connect(_leave)

func _process(delta: float) -> void:
	MyMethodForAviodance(delta)

func Avoid(delta: float):
	var pos_sum = Vector2.ZERO	
	var relative_pos_sum = Vector2.ZERO

	for body_id in near_by_boids:
		var body = near_by_boids[body_id]
		relative_pos_sum += position - body.position
		# prints("local ps:", to_local(position - body.position), " id: ", this_id)
		# prints("relative_pos_sum: ", relative_pos_sum, " id: ", this_id)
		
	if relative_pos_sum != Vector2.ZERO:
		var inverse = relative_pos_sum/Vector2(pow(relative_pos_sum.x, 2), pow(relative_pos_sum.y, 2))
		if debug:
			prints(inverse)
		dir = dir + inverse*10

	dir = dir.normalized() 
	position += dir * speed * delta
	rotation = lerp_angle(rotation, dir.angle_to_point(Vector2.ZERO),0.4)

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
	var parent = body.get_parent()
	var body_id = parent.get_instance_id()
	if body_id != this_id:
		near_by_boids[body_id] = parent
	

func _leave(body: Node2D):
	var parent = body.get_parent()
	var body_id = parent.get_instance_id()
	near_by_boids.erase(body_id)
