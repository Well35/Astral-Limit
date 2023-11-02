extends Area2D

var speed: int = 300
var direction: Vector2

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()
