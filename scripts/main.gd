extends Node2D

var temp_shoot: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var simple_enemy_laser: PackedScene = preload("res://scenes/projectiles/enemy_laser.tscn")
var swarmer: PackedScene = preload("res://scenes/enemies/swarmer.tscn")
var orbiter_bullet: PackedScene = preload("res://scenes/projectiles/orbiter_bullet.tscn")
var bomb_scene: PackedScene = preload("res://scenes/projectiles/bomb.tscn")
var radar_mar = preload("res://scenes/enemies/radar_marker.tscn")
@onready var radar_level = $UI/SubViewportContainer/SubViewport/RadarLevel
@onready var radar_cam = $UI/SubViewportContainer/SubViewport/RadarLevel/Camera2D
@onready var boss = $Enemies/Boss/BattlecruiserBoss

@onready var wave1 = $Enemies/Wave1.get_children()
@onready var wave2 = $Enemies/Wave2.get_children()
@onready var wave3 = $Enemies/Wave3.get_children()

var wave1_freed: bool = false
var wave2_freed: bool = false
var wave3_freed: bool = false
var boss_stage2: bool = false

var curr_wave: int = 1
# Called when the node enters the scene tree for the first time.
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
	#$UI/ColorRect.show()
	#var fade_time = 1
	#var tween = get_tree().create_tween()
	#tween.tween_property($UI/ColorRect, "modulate:a", 0, fade_time)
	Globals.fade_in_scene($UI/ColorRect)
	$AudioStreamPlayer.play(Globals.music_pos)
	Globals.boss_dest = $BossStart.position
	Globals.boss_right = $BossRightStrafe.position
	Globals.boss_left = $BossLeftStrafe.position
	#for enemy in wave1:
	#	enemy.process_mode = Node.PROCESS_MODE_DISABLED
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

func _on_orbiter_orbiter_shoot(pos, dir):
	var bullet = orbiter_bullet.instantiate()
	bullet.position = pos
	bullet.direction = dir
	bullet.rotation_degrees = rad_to_deg(dir.angle()) + 90
	$Projectiles.add_child(bullet)


func _on_simple_enemy_enemy_laser(pos, dir):
	var laser = simple_enemy_laser.instantiate()
	laser.position = pos
	laser.direction = dir
	laser.rotation_degrees = rad_to_deg(dir.angle()) + 90
	$Projectiles.add_child(laser)


func _on_battlecruiser_boss_spawn_swarmers():
	var x = randi_range(3,8)
	var spawns = $SwarmerSpawns.get_children()
	var e = randi_range(0,spawns.size()-1)
	for i in range(x):
		var enemy = swarmer.instantiate()
		enemy.position = spawns[e].position
		$Enemies/Boss.add_child(enemy)


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
