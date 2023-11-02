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

func _process(delta):
	destination = Globals.player_pos
	if (health <= 0) and not is_dead:
		is_dead = true
		$dead.play()
		$Sprite2D.hide()
		$CollisionShape2D.disabled = true
		#queue_free()
	if not at_destination:
		direction = (destination - position).normalized()
		look_at(destination)
		velocity = direction * speed
		move_and_slide()
		if position.distance_to(destination) < 200:
			at_destination = true
	else:
		look_at(Globals.player_pos)
		if can_shoot and not is_dead:
			$LaserTimer.start()
			can_shoot = false
			laser_dir = (Globals.player_pos - position).normalized()
			enemy_laser.emit($BulletStart.global_position, laser_dir)

func _on_laser_timer_timeout():
	can_shoot = true

func hit(dmg):
	health -= dmg


func _on_dead_finished():
	queue_free()
