extends CharacterBody2D

var laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")

var health: int = 10
var speed: int = 200
var direction: Vector2
@onready var start: Vector2
var is_dead: bool = false

signal update_location(loc)
signal free_marker

func _ready():
	$AnimationPlayer.play("Engine")

func _process(delta):
	if (health <= 0) and not is_dead:
		free_marker.emit()
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
		is_dead = true
		$dead.play()
		$explosion.show()
		$AnimationPlayer.play("dead")
		$Sprite2D.hide()
		$Engine.hide()
		$CollisionPolygon2D.disabled = true
		var markers = $Markers.get_children()
		for m in markers:
			var temp = laser.instantiate()
			temp.position = m.global_position
			temp.direction = (position - temp.position).normalized()
			temp.rotation_degrees = rad_to_deg(temp.direction.angle()) + 90
			get_parent().get_parent().get_parent().get_child(3).add_child(temp)
	if not is_dead:
		direction = (Globals.player_pos - position).normalized()
		look_at(Globals.player_pos)
		velocity = direction * speed
		move_and_slide()
	update_location.emit(global_position)

func hit(dmg):
	health -= dmg


func _on_dead_finished():
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()
	elif anim_name == "Engine":
		$AnimationPlayer.play("Engine")
