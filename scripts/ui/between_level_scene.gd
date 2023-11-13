extends Node2D

var button_green = load("res://assets/sprites/button_green.png")
var button_green_hovered = load("res://assets/sprites/button_green_hovered.png")
var button_red = load("res://assets/sprites/button_red.png")
var button_red_hovered = load("res://assets/sprites/button_red_hovered.png")


func _ready():
	Globals.fade_in_scene($BetweenLevelUI/ColorRect)
	$AudioStreamPlayer.play(Globals.music_pos)
	var buttons = $Buttons.get_children()
	for i in Globals.levels_completed.size():
		if Globals.levels_completed[i] == true:
			buttons[i].texture_normal = button_green
			buttons[i].texture_hover = button_green_hovered
			if i < buttons.size()-1:
				buttons[i+1].texture_normal = button_red
				buttons[i+1].texture_hover = button_red_hovered

func _on_button_pressed():
	#Globals.fade_out_scene($BetweenLevelUI/ColorRect)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_level_2_button_pressed():
	if Globals.levels_completed[0] == true:
		get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")


func _on_level_3_button_pressed():
	if Globals.levels_completed[1] == true:
		get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")
