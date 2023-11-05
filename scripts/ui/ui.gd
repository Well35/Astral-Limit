extends CanvasLayer

@onready var heart = $MarginContainer/HBoxContainer/TextureRect

func _ready():
	Globals.connect("boss_health_change", update_boss_health)
	Globals.connect("player_health_change", update_player_health)
	$BossHealth.value = Globals.boss_health

func _process(delta):
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
	var temp = hearts.back()
	temp.queue_free()


#func _on_dread_boss_display_health_bar():
#	$BossHealth.show()

func _on_dread_boss_initial_health_bar(h):
	$BossHealth.max_value = h
	$BossHealth.show()
