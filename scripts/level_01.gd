extends ColorRect


func _on_level_1_button_pressed():
	SceneManager.switch_scene("res://scenes/level_02.tscn")


func _on_level_1_button_2_pressed():
	SceneManager.transition_scene("res://scenes/level_02.tscn", "shrink_out")


func _on_level_1_button_3_pressed():
	SceneManager.transition_scene("res://scenes/level_02.tscn", "fade_in_out")
