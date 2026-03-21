extends Node2D


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/main_game.tscn")


func _on_settings_pressed() -> void:
	$MainContainer/MainMenu.visible = false
	$MainContainer/SettingsMenu.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$MainContainer/MainMenu.visible = true
	$MainContainer/SettingsMenu.visible = false


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
