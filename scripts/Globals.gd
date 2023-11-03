extends Node

var player_invul: bool = false
var music_pos: float
var play_area_timer_pos: float
var player_pos: Vector2
var boss_dest: Vector2
var boss_right: Vector2
var boss_left: Vector2
var boss_dead: bool
var outside_play_area: bool = false
var player_shooting: bool = false
var player_dashing: bool = false

signal boss_health_change
signal player_health_change

var boss_health = 500:
	get:
		return boss_health
	set(value):
		boss_health = value
		boss_health_change.emit()

var player_health: int = 3:
	get:
		return player_health
	set(value):
		player_health = value
		player_health_change.emit()

#scene fades in from black
var color_rect: ColorRect
func fade_in_scene(c: ColorRect):
	c.modulate.a = 1
	color_rect = c
	c.show()
	var fade_time = 1
	var tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.tween_property(c, "modulate:a", 0, fade_time)

func fade_out_scene(c: ColorRect):
	c.modulate.a = 0
	color_rect = c
	c.show()
	var fade_time = 1
	var tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.tween_property(c, "modulate:a", 1, fade_time)
	await tween.finished

func on_tween_finished():
	color_rect.hide()
