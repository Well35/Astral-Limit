extends CharacterBody2D

@onready var direction: Vector2
var start_location: Vector2
var spawn_location: Vector2
var left: Vector2
var right: Vector2
var speed: int = 180
var at_start: bool
var at_right: bool = false
var at_left: bool = true
var can_shoot: bool = false
var health: int = 500
var max_health: int = 500
var accel = 1200
var friction = 800
var laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")
var stage1: bool = true
var stage2: bool = false
var stage3: bool = false

var immune: bool = false

signal enemy_laser(pos, dir)
signal spawn_swarmers
signal on_screen
signal bomb
signal stage2_over
signal update_location(loc)
signal free_marker

func _ready():
	direction = (position - start_location).normalized()
	spawn_location = position

func _process(delta):
	if Globals.boss_health <= 0:
		free_marker.emit()
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
		can_shoot = false
		$AnimationPlayer.play("dead")
	health = Globals.boss_health
	start_location = Globals.boss_dest
	left = Globals.boss_left
	right = Globals.boss_right
	if health <= max_health / 2 and health >= max_health/4 and stage2 == false and stage3 == false:
		Globals.boss_health = max_health / 2
		stage1 = false
		stage2 = true
		can_shoot = false
		move_off_screen()
	if stage1:
		if not at_start:
			direction = (start_location - position).normalized()
		velocity = direction * speed
		move_and_slide()
		if not at_start and position.distance_to(start_location) < 10:
			at_start = true
			can_shoot = true
			on_screen.emit()
		if can_shoot:
			#this needs to be rewritten
			$LaserReloadTimer.start()
			can_shoot = false
			var l = laser.instantiate()
			l.direction = Vector2.DOWN
			l.position = $MiddleLaser.global_position
			l.rotation_degrees = rad_to_deg(l.direction.angle()) + 90
			get_parent().get_parent().get_child(3).add_child(l)
			#enemy_laser.emit($MiddleLaser.global_position, dir)
			l = laser.instantiate()
			l.direction = Vector2(.6,1)
			l.position = $MiddleLaser.global_position
			l.rotation_degrees = rad_to_deg(l.direction.angle()) + 90
			get_parent().get_parent().get_child(3).add_child(l)
			#enemy_laser.emit($LeftLaser.global_position, dir)
			l = laser.instantiate()
			l.direction = Vector2(-.6,1)
			l.position = $MiddleLaser.global_position
			l.rotation_degrees = rad_to_deg(l.direction.angle()) + 90
			get_parent().get_parent().get_child(3).add_child(l)
			#enemy_laser.emit($RightLaser.global_position, dir)
		if at_start:
			if at_right:
				direction = Vector2.LEFT
			if at_left:
				direction = Vector2.RIGHT
			if at_left and position.distance_to(right) < 100:
				at_right = true
				at_left = false
			if at_right and position.distance_to(left) < 100:
				at_left = true
				at_right = false
	if stage2:
		velocity += direction * accel * delta
		velocity.x = 0
		velocity = velocity.limit_length(speed)
		move_and_slide()
	update_location.emit(global_position)

func _on_laser_reload_timer_timeout():
	can_shoot = true

func hit(dmg):
	if not immune:
		Globals.boss_health -= dmg

func move_off_screen():
	$Shield.show()
	$AnimationPlayer.play("shield")
	immune = true
	speed = 1300
	direction = Vector2.DOWN
	$IntermissionTimer.start()
	$Stage2Timer.start()
	bomb.emit()


func _on_intermission_timer_timeout():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO


func _on_swarmer_spawn_timer_timeout():
	if stage2 or stage3:
		spawn_swarmers.emit()


func _on_stage_2_timer_timeout():
	position = spawn_location
	$Shield.hide()
	at_start = false
	stage2 = false
	stage1 = true
	stage3 = true
	speed = 250
	immune = false
	stage2_over.emit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dead":
		#get_tree().change_scene_to_file("res://scenes/ui/end_screen.tscn")
		queue_free()
