@tool
extends CollisionPolygon2D

@export var radius: float = 100.0 : set = set_radius
@export_range(0, 360) var start_angle: float = 0.0 : set = set_start_angle
@export_range(0, 360) var end_angle: float = 90.0 : set = set_end_angle
@export_range(3, 32) var resolution: int = 10 : set = set_resolution

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_polygon():
	var points = [Vector2.ZERO]  # Center point
	
	var start_rad = deg_to_rad(start_angle)
	var end_rad = deg_to_rad(end_angle)
	
	# Handle case where end_angle is less than start_angle
	if end_rad < start_rad:
		end_rad += deg_to_rad(360)
	
	# Add points along the arc
	for i in range(resolution + 1):
		var angle = start_rad + (end_rad - start_rad) * i / resolution
		var point = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)
	
	polygon = points


func set_radius(value):
	radius = value
	update_polygon()

func set_start_angle(value):
	start_angle = value
	update_polygon()

func set_end_angle(value):
	end_angle = value
	update_polygon()

func set_resolution(value):
	resolution = value
	update_polygon()
