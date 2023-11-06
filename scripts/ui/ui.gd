extends CanvasLayer

@onready var heart = preload("res://scenes/ui/heart.tscn")

func _ready():
	Globals.connect("boss_health_change", update_boss_health)
	Globals.connect("player_health_change", update_player_health)
	$BossHealth.value = Globals.boss_health

func _process(delta):
	$PlayerHealthRegen.value = abs($HealthIncreaseTimer.time_left - 5)
	var fps: String = "FPS: %s" % [Engine.get_frames_per_second()]
	$FpsCounter.text = fps
	if Globals.boss_health < 0:
		$BossHealth.hide()
	if Globals.outside_play_area:
		$MarginContainer2/VBoxContainer/PlayAreaWarning.show()
		$MarginContainer2/VBoxContainer/OutOfBoundsTimer.show()
		$MarginContainer2/VBoxContainer/OutOfBoundsTimer.text = str(Globals.play_area_timer_pos).pad_decimals(2)
	else:
		$MarginContainer2/VBoxContainer/PlayAreaWarning.hide()
		$MarginContainer2/VBoxContainer/OutOfBoundsTimer.hide()

func update_boss_health():
	$BossHealth.value = Globals.boss_health

func _on_battlecruiser_boss_on_screen():
	$BossHealth.show()

func update_player_health():
	if Globals.player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	var hearts = $MarginContainer/HBoxContainer.get_children()
	if hearts.size() > Globals.player_health:
		var temp = hearts.back()
		temp.queue_free()
	else:
		var heart_instance = heart.instantiate()
		$MarginContainer/HBoxContainer.add_child(heart_instance)


#func _on_dread_boss_display_health_bar():
#	$BossHealth.show()

func _on_dread_boss_initial_health_bar(h):
	$BossHealth.max_value = h


func _on_health_increase_timer_timeout():
	if Globals.player_health < 3:
		Globals.player_health += 1
