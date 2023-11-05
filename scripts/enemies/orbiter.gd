extends CharacterBody2D

var d = 0
var radius = 260
var speed = .9
var norm_speed = 400

var health: int = 10
var laser_dir: Vector2
var at_destination: bool = false
var direction: Vector2 = Vector2.ZERO
@onready var destination: Vector2
@onready var can_shoot: bool = false
var is_dead: bool = false

signal orbiter_shoot(pos, dir)
signal update_location(loc)
signal free_marker

func _ready():
	destination = Globals.player_pos

func _process(delta):
	var player_to_enemy: Vector2 = Globals.player_pos - position
	destination = Globals.player_pos
	if not at_destination and position.distance_to(destination) < radius and not is_dead:
		at_destination = true
		d = atan2(position.y - Globals.player_pos.y, position.x - Globals.player_pos.x)
		#print(d)
		can_shoot = true
	if at_destination and not is_dead:
		d += delta
		position = Vector2(sin(d) * radius, cos(d) * radius) + Globals.player_pos
		look_at(Globals.player_pos)
	elif not is_dead:
		direction = (destination - position).normalized()
		look_at(destination)
		velocity = direction * norm_speed
	if (health <= 0) and not is_dead:
		free_marker.emit()
		is_dead = true
		$dead.play()
		$Sprite2D.hide()
		$DeadExplosion.show()
		$DeadExplosion.play("default")
		$CollisionShape2D.disabled = true
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
	move_and_slide()
	if can_shoot and not is_dead:
		$BulletTimer.start()
		can_shoot = false
		orbiter_shoot.emit($BulletStart.global_position, (Globals.player_pos - position).normalized())
	update_location.emit(global_position)

func hit(dmg):
	health -= dmg


func _on_bullet_timer_timeout():
	can_shoot = true


func _on_dead_finished():
	queue_free()
