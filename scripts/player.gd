extends CharacterBody2D

var speed: int = 340
var dash_speed: int = 700
var can_shoot: bool = true
var is_shooting: bool = false
var accel = 3000
var friction = 600
var immune: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var direction: Vector2
var dash_direction: Vector2

var is_idle: bool = true
var idle_anim_playing: bool = false
var moving_anim_playing: bool = false

signal player_shoot(pos, dir)

func _ready():
	$AnimationPlayer.play("EngineIdle")
	Globals.player_pos = position

func _process(delta):
	look_at(get_global_mouse_position())
	if not is_dashing:
		direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		if velocity.length() > friction * delta:
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity += direction * accel * delta
		velocity = velocity.limit_length(speed)
	if is_dashing:
		dash_direction = direction
		velocity = dash_direction * dash_speed
	move_and_slide()
	if direction != Vector2.ZERO:
		is_idle = false
	else:
		is_idle = true
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
	if Input.is_action_pressed("dash") and can_dash:
		$DashCooldown.start()
		$DashDuration.start()
		set_collision_layer_value(1, false)
		can_dash = false
		is_dashing = true
		immune = true
	if is_shooting:
		if $ShootingSound.get_playback_position() == 0:
			$ShootingSound.play()
	Globals.player_dashing = is_dashing
	if is_idle and not idle_anim_playing:
		$AnimationPlayer.play("EngineIdle")
		$EngineIdle.show()
		$EngineMoving.hide()
		idle_anim_playing = true
		moving_anim_playing = false
	elif not is_idle and not moving_anim_playing:
		$AnimationPlayer.play("EngineMoving")
		$EngineIdle.hide()
		$EngineMoving.show()
		idle_anim_playing = false
		moving_anim_playing = true

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

func _on_dash_cooldown_timeout():
	can_dash = true

func _on_dash_duration_timeout():
	is_dashing = false
	set_collision_layer_value(1, true)
	immune = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "EngineIdle":
		idle_anim_playing = false
	if anim_name == "EngineMoving":
		moving_anim_playing = false
