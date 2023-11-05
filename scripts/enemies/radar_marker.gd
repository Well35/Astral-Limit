extends Sprite2D


func on_update_location(loc):
	global_position = loc / 12

func on_free_marker():
	queue_free()
