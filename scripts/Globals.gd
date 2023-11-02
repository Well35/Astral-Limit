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

