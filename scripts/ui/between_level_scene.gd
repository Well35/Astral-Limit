extends Node2D

func _ready():
	Globals.fade_in_scene($BetweenLevelUI/ColorRect)
	$AudioStreamPlayer.play(Globals.music_pos)

func _on_button_pressed():
	#Globals.fade_out_scene($BetweenLevelUI/ColorRect)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
