extends MarginContainer

func _ready():
	Globals.player_health = 3
	Globals.boss_health = 500
	$AudioStreamPlayer.play(Globals.music_pos)

func _on_play_pressed():
	$AnimationPlayer.play("fade_black")


func _on_settings_pressed():
	Globals.music_pos = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	Globals.music_pos = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://scenes/ui/between_level_scene.tscn")
