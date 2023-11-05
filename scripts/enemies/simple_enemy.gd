extends CharacterBody2D

var health: int = 30
var is_dead: bool = false
var at_destination: bool = false
@onready var can_shoot: bool = true
var speed: int = 350
var laser_dir: Vector2
var direction: Vector2 = Vector2.ZERO
var laser_scene = preload("res://scenes/projectiles/enemy_laser.tscn")
@onready var start: Vector2
@onready var destination: Vector2

signal enemy_laser(pos, dir)
signal update_location(loc)
signal free_marker

func _process(delta):
	destination = Globals.player_pos
	if (health <= 0) and not is_dead:
		free_marker.emit()
		is_dead = true
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
		$dead.play()
		$explosion.show()
		$AnimationPlayer.play("dead")
		$Sprite2D.hide()
		$CollisionShape2D.disabled = true
		#queue_free()
	if not at_destination and not is_dead:
		direction = (destination - position).normalized()
		look_at(destination)
		velocity = direction * speed
		move_and_slide()
		if position.distance_to(destination) < 200:
			at_destination = true
	elif not is_dead:
		look_at(Globals.player_pos)
		if can_shoot and not is_dead:
			$LaserTimer.start()
			can_shoot = false
			laser_dir = (Globals.player_pos - position).normalized()
			enemy_laser.emit($BulletStart.global_position, laser_dir)
	update_location.emit(global_position)

func _on_laser_timer_timeout():
	can_shoot = true

func hit(dmg):
	health -= dmg


func _on_dead_finished():
	pass


func _on_animation_player_animation_finished(anim_name):
	queue_free()
