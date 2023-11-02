extends MarginContainer


func _ready():
	$AudioStreamPlayer.play(Globals.music_pos)

func _on_exit_pressed():
	get_tree().quit()
