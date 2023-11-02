extends MarginContainer



func _ready():
	$AudioStreamPlayer.play(Globals.music_pos)


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		Globals.player_invul = true
	else:
		Globals.player_invul = false


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
