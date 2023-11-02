extends Area2D

var speed: int = 1700
var direction: Vector2
var damage: int = 3
var exploded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not exploded:
		position += direction * speed * delta


func _on_body_entered(body):
	$explode.show()
	$Sprite2D.hide()
	$explode.play("explode")
	exploded = true
	#queue_free()
	if body.has_method("hit"):
		body.hit(damage)


func _on_explode_animation_finished():
	queue_free()
