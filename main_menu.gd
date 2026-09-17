extends Control

func _on_button_pressed():
	$ButtonSound.play()
	await $ButtonSound.finished
	get_tree().change_scene_to_file("res://Question.tscn")
