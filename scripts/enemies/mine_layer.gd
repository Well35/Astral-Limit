extends CharacterBody2D

var mine = preload("res://scenes/projectiles/bomb.tscn")

var destination: Vector2
var direction: Vector2
var speed = 300
var health = 15

signal update_location(loc)
signal free_marker

func _ready():
	calculate_destination()
	$MineLayingTimer.start()

func _process(delta):
	if health <= 0:
		free_marker.emit()
		queue_free()
	if position.distance_to(destination) < 10:
		calculate_destination()
	velocity = direction * speed
	move_and_slide()
	update_location.emit(global_position)
	look_at(destination)

func calculate_destination():
	destination.x = randi_range(Globals.play_area_x.x,  Globals.play_area_x.y)
	destination.y = randi_range(Globals.play_area_y.x,  Globals.play_area_y.y)
	direction = (destination - position).normalized()

func _on_mine_laying_timer_timeout():
	var mine_instance = mine.instantiate()
	mine_instance.position = position
	get_parent().get_parent().get_parent().get_child(3).add_child(mine_instance)

func hit(dmg):
	health -= dmg
