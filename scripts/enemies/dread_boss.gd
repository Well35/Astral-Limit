extends CharacterBody2D

var bullet: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")
var shotgun_angle = 70
var shotgun_bullets = 8
var omni_bullets = 20
var speed = 300
var direction: Vector2
var stage2: bool = false

var health = 1000

signal display_health_bar
signal initial_health_bar(h)
signal update_location(loc)
signal free_marker

func _process(delta):
	if position.distance_to(Globals.player_pos) < 800:
		speed = 50
	if health <= 0:
		free_marker.emit()
		queue_free()
	if not stage2:
		look_at(Globals.player_pos)
		direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		self.rotation_degrees += .8
	update_location.emit(global_position)

func _ready():
	Globals.boss_health = health
	#display_health_bar.emit()
	initial_health_bar.emit(health)

func shotgun_attack():
	var step = shotgun_angle / shotgun_bullets
	var half_angle = shotgun_angle/2
	for i in range(shotgun_bullets):
		var b = bullet.instantiate()
		b.position = $FrontShotMarker.global_position
		var rotation = deg_to_rad(i*step-half_angle)
		b.direction = (Globals.player_pos - position).normalized().rotated(rotation)
		b.rotation_degrees = rad_to_deg(b.direction.angle()) + 90
		b.speed = 500
		get_parent().get_parent().get_child(3).add_child(b)

func omni_direction_attack():
	var angle = 2 * PI
	var step = angle / omni_bullets
	for i in range(omni_bullets):
		var b = bullet.instantiate()
		b.position = $MidShotMarker.global_position
		var rotation =  i*step
		b.direction = (Globals.player_pos - position).normalized().rotated(rotation)
		b.rotation_degrees = rad_to_deg(b.direction.angle()) + 90
		get_parent().get_parent().get_child(3).add_child(b)

func _on_reload_timer_timeout():
	shotgun_attack()


func _on_omni_shot_timer_timeout():
	omni_direction_attack()

func hit(dmg):
	Globals.boss_health -= dmg
	health -= dmg


func _on_stage_switch_timer_timeout():
	$ReloadTimer.stop()
	$OmniShotTimer.wait_time = .18
	$OmniShotTimer.stop()
	$OmniShotTimer.start()
	stage2 = true
	$Stage2Timer.start()


func _on_stage_2_timer_timeout():
	stage2 = false
	$ReloadTimer.start()
	$OmniShotTimer.wait_time = 1.3
	$Stage1Timer.start()
