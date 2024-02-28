extends ColorRect


func _on_level_2_button_pressed():
	SceneManager.switch_scene("res://scenes/level_01.tscn")
	


func _on_level_2_button_2_pressed():
	SceneManager.transition_scene("res://scenes/level_01.tscn", "swipe_in_out_right")
