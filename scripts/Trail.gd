extends Line2D

@onready var parent = get_parent()
var length = 4

func _ready():
	top_level = true
	clear_points()

func _physics_process(delta):
	add_point(parent.global_position)
	if points.size() > length:
		remove_point(0)
