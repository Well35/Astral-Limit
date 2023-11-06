extends level

func _ready():
	super._ready()

func _process(delta):
	super._process(delta)
	if Globals.level_over:
		Globals.levels_completed[1] = true
		get_tree().change_scene_to_file("res://scenes/ui/between_level_scene.tscn")
		Globals.level_over = false
