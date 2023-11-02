extends CharacterBody2D

var laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")

var health: int = 10
var speed: int = 200
var direction: Vector2
@onready var start: Vector2
var is_dead: bool = false

func _process(delta):
	if (health <= 0) and not is_dead:
		is_dead = true
		$dead.play()
		$Sprite2D.hide()
		$CollisionPolygon2D.disabled = true
		var markers = $Markers.get_children()
		for m in markers:
			var temp = laser.instantiate()
			temp.position = m.global_position
			temp.direction = (position - temp.position).normalized()
			temp.rotation_degrees = rad_to_deg(temp.direction.angle()) + 90
			get_parent().get_parent().get_child(3).add_child(temp)
	direction = (Globals.player_pos - position).normalized()
	look_at(Globals.player_pos)
	velocity = direction * speed
	move_and_slide()

func hit(dmg):
	health -= dmg


func _on_dead_finished():
	queue_free()
