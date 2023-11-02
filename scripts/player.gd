extends CharacterBody2D

var speed: int = 340
var can_shoot: bool = true
var is_shooting: bool = false
var accel = 3000
var friction = 600
var immune: bool = false

signal player_shoot(pos, dir)

func _ready():
	Globals.player_pos = position

func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		if velocity.length() > friction * delta:
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity += direction * accel * delta
		velocity = velocity.limit_length(speed)
	move_and_slide()
	look_at(get_global_mouse_position())
	Globals.player_pos = position
	if Input.is_action_pressed("shoot") and can_shoot:
		is_shooting = true
		var dir = (get_global_mouse_position() - position).normalized()
		player_shoot.emit($BulletStart.global_position, dir)
		can_shoot = false
		$LaserTimer.start()
	elif Input.is_action_just_released("shoot"):
		is_shooting = false
		$ShootingSound.stop()
		$ShootingSound.seek(0)
	if is_shooting:
		if $ShootingSound.get_playback_position() == 0:
			$ShootingSound.play()

func _on_laser_timer_timeout():
	can_shoot = true

func hit():
	if not immune:
		Globals.player_health -= 1
		immune = true
		$ImmuneTimer.start()

func _on_immune_timer_timeout():
	if not Globals.player_invul:
		immune = false

func turn_off_ship(sprite, collision):
	sprite.hide()
	collision.disabled = true

func turn_on_ship(sprite, collision):
	sprite.show()
	collision.disabled = false
