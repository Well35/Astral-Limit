extends Node2D

#TODO: refactor code in this file to inherit from the base level script
##     also need to remove most references to the Globals script/most of the current signals

var temp_shoot: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var simple_enemy_laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")
var swarmer: PackedScene = preload("res://scenes/enemies/swarmer.tscn")
var bomb_scene: PackedScene = preload("res://scenes/projectiles/bomb.tscn")
var radar_mar = preload("res://scenes/enemies/radar_marker.tscn")
@onready var radar_level = $UI/SubViewportContainer/SubViewport/RadarLevel
@onready var radar_cam = $UI/SubViewportContainer/SubViewport/RadarLevel/Camera2D
@onready var boss = $Enemies/Boss/BattlecruiserBoss

@onready var wave1 = $Enemies/Wave1.get_children()
@onready var wave2 = $Enemies/Wave2.get_children()
@onready var wave3 = $Enemies/Wave3.get_children()

var boss_stage2: bool = false

var curr_wave: int = 1
func _ready():
	Globals.play_area_x = Vector2(500, 3500)
	Globals.play_area_y = Vector2(500, 3000)
	for enemies in $Enemies.get_children():
		for enemy in enemies.get_children():
			var marker = radar_mar.instantiate()
			marker.global_position = Vector2.ZERO
			radar_level.add_child(marker)
			enemy.update_location.connect(marker.on_update_location)
			enemy.free_marker.connect(marker.on_free_marker)
	Globals.fade_in_scene($UI/ColorRect)
	$AudioStreamPlayer.play(Globals.music_pos)
	Globals.boss_dest = $BossStart.position
	Globals.boss_right = $BossRightStrafe.position
	Globals.boss_left = $BossLeftStrafe.position
	for enemy in wave2:
		enemy.process_mode = Node.PROCESS_MODE_DISABLED
	for enemy in wave3:
		enemy.process_mode = Node.PROCESS_MODE_DISABLED
	$Enemies/Boss/BattlecruiserBoss.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	var waves = $Enemies.get_children()
	radar_cam.global_position = Globals.player_pos / 12
	Globals.music_pos = $AudioStreamPlayer.get_playback_position()
	if waves[curr_wave-1].get_children().size() == 0:
		if curr_wave == waves.size():
			Globals.levels_completed[0] = true
			get_tree().change_scene_to_file("res://scenes/ui/between_level_scene.tscn")
		else:
			for enemy in waves[curr_wave].get_children():
				enemy.process_mode = PROCESS_MODE_ALWAYS
			curr_wave += 1
	if Input.is_action_pressed("close"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	if boss_stage2:
		var x = randi_range(0, 1000)
		var y = randi_range(0, 1000)
		var pos: Vector2
		pos.x = x
		pos.y = y
	if $OutOfBoundsTimer.time_left > 0:
		Globals.play_area_timer_pos = $OutOfBoundsTimer.time_left

func _on_player_player_shoot(pos, dir):
	var laser = temp_shoot.instantiate()
	laser.position = pos
	laser.direction = dir
	laser.rotation_degrees = rad_to_deg(dir.angle()) + 90
	$Projectiles.add_child(laser)

func _on_battlecruiser_boss_spawn_swarmers():
	pass
	"""
	var x = randi_range(1,3)
	var spawns = $SwarmerSpawns.get_children()
	var e = randi_range(0,spawns.size()-1)
	for i in range(x):
		var enemy = swarmer.instantiate()
		enemy.position = spawns[e].position
		$Enemies/Wave1.add_child(enemy)
	"""

func _on_battlecruiser_boss_bomb():
	$BossBombTimer.start()
	boss_stage2 = true

func _on_boss_bomb_timer_timeout():
	for i in range(5):
		var x = randi_range(500, 3500)
		var y = randi_range(500, 3000)
		var pos: Vector2
		pos.x = x
		pos.y = y
		var bomb = bomb_scene.instantiate()
		bomb.position = pos
		$Projectiles.add_child(bomb)

func _on_battlecruiser_boss_stage_2_over():
	$BossBombTimer.stop()

func _on_play_area_body_exited(body):
	if get_node("Player") == body:
		$OutOfBoundsTimer.start()
		Globals.outside_play_area = true


func _on_out_of_bounds_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_play_area_body_entered(body):
	$OutOfBoundsTimer.stop()
	Globals.outside_play_area = false
