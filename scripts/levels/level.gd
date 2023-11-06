extends Node2D
class_name level

var radar_mar = preload("res://scenes/enemies/radar_marker.tscn")
var temp_shoot: PackedScene = preload("res://scenes/projectiles/laser.tscn")
@onready var radar_level = $UI/SubViewportContainer/SubViewport/RadarLevel
@onready var radar_cam = $UI/SubViewportContainer/SubViewport/RadarLevel/Camera2D

var curr_wave: int = 1

func _ready():
	for enemies in $Enemies.get_children():
		for enemy in enemies.get_children():
			var marker = radar_mar.instantiate()
			marker.global_position = Vector2.ZERO
			radar_level.add_child(marker)
			enemy.update_location.connect(marker.on_update_location)
			enemy.free_marker.connect(marker.on_free_marker)
	Globals.fade_in_scene($UI/ColorRect)
	$AudioStreamPlayer.play(Globals.music_pos)
	disable_enemies()

func _process(delta):
	var waves = $Enemies.get_children()
	radar_cam.global_position = Globals.player_pos / 12
	Globals.music_pos = $AudioStreamPlayer.get_playback_position()
	if waves[curr_wave-1].get_children().size() == 0:
		if curr_wave == waves.size():
			Globals.level_over = true
		else:
			for enemy in waves[curr_wave].get_children():
				enemy.process_mode = PROCESS_MODE_ALWAYS
			curr_wave += 1
	if Input.is_action_pressed("close"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	if $OutOfBoundsTimer.time_left > 0:
		Globals.play_area_timer_pos = $OutOfBoundsTimer.time_left
	if curr_wave == waves.size():
		$UI/BossHealth.show()

func disable_enemies():
	for enemies in $Enemies.get_children():
		for enemy in enemies.get_children():
			if enemies.name != "Wave1":
				enemy.process_mode = Node.PROCESS_MODE_DISABLED


func _on_out_of_bounds_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_play_area_body_entered(body):
	$OutOfBoundsTimer.stop()
	Globals.outside_play_area = false


func _on_play_area_body_exited(body):
	if get_node("Player") == body:
		$OutOfBoundsTimer.start()
		Globals.outside_play_area = true


func _on_player_player_shoot(pos, dir):
	var laser = temp_shoot.instantiate()
	laser.position = pos
	laser.direction = dir
	laser.rotation_degrees = rad_to_deg(dir.angle()) + 90
	$Projectiles.add_child(laser)
