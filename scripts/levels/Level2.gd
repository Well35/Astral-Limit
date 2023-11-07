extends level

func _ready():
	super._ready()
	Globals.play_area_x = Vector2(-100, 4000)
	Globals.play_area_y = Vector2(500, 3000)

func _process(delta):
	super._process(delta)
	if Globals.level_over:
		Globals.levels_completed[1] = true
		get_tree().change_scene_to_file("res://scenes/ui/between_level_scene.tscn")
		Globals.level_over = false
