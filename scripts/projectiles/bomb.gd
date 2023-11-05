extends Area2D

var laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")

func _on_explosion_timer_timeout():
	$Sprite2D.hide()
	var markers = $Markers.get_children()
	print(markers[3].global_position)
	for m in markers:
		var temp = laser.instantiate()
		temp.position = m.global_position
		temp.direction = (position - temp.position).normalized()
		temp.rotation_degrees = rad_to_deg(temp.direction.angle()) + 90
		temp.speed -= 300
		get_parent().add_child(temp)

func _on_destroy_timer_timeout():
	queue_free()
