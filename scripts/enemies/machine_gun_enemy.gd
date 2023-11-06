extends CharacterBody2D

var laser = preload("res://scenes/projectiles/enemy_laser.tscn")

var direction: Vector2
var speed = 400
var shooting_angle = 50
var health = 20
var is_shooting: bool = false

signal update_location(loc)
signal free_marker

func _process(delta):
	if health <= 0:
		free_marker.emit()
		queue_free()
	direction = (Globals.player_pos - position).normalized()
	look_at(Globals.player_pos)
	if position.distance_to(Globals.player_pos) < 800 and not is_shooting:
		is_shooting = true
		speed = 80
		$ReloadTimer.start()
	velocity = direction * speed
	move_and_slide()
	update_location.emit(global_position)

func _on_reload_timer_timeout():
	var angle = shooting_angle / 2
	var rand_angle = randf_range(0, angle)
	var rand_neg = randi_range(0,1)
	var laser_instance = laser.instantiate()
	laser_instance.position = $BulletStart.global_position
	if rand_neg:
		rand_angle = -rand_angle
	laser_instance.direction = (Globals.player_pos - position).normalized().rotated(deg_to_rad(rand_angle))
	laser_instance.rotation_degrees = rad_to_deg(laser_instance.direction.angle()) + 90
	laser_instance.speed = 500
	get_parent().get_parent().get_child(3).add_child(laser_instance)

func hit(dmg):
	health -= dmg
