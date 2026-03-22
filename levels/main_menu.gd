extends Node2D


func _on_play_pressed() -> void:
	$MainContainer/MainMenu/Play/Clic.play()
	get_tree().change_scene_to_file("res://levels/main_game.tscn")

func _on_play_mouse_entered() -> void:
	$MainContainer/MainMenu/Play/Hover.play()

func _on_settings_pressed() -> void:
	$MainContainer/MainMenu/Settings/Clic.play()
	$MainContainer/MainMenu.visible = false
	$MainContainer/SettingsMenu.visible = true

func _on_settings_mouse_entered() -> void:
	$MainContainer/MainMenu/Settings/Hover.play()

func _on_quit_pressed() -> void:
	$MainContainer/MainMenu/Quit/Clic.play()
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	$MainContainer/MainMenu/Quit/Hover.play()

func _on_back_pressed() -> void:
	$MainContainer/SettingsMenu/Back/Clic.play()
	$MainContainer/MainMenu.visible = true
	$MainContainer/SettingsMenu.visible = false
	
func _on_back_mouse_entered() -> void:
	$MainContainer/SettingsMenu/Back/Hover.play()

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_volume_slider_drag_started() -> void:
	$MainContainer/SettingsMenu/VolumeContainer/VolumeSlider/Clic.play()

func _on_volume_slider_mouse_entered() -> void:
	$MainContainer/SettingsMenu/VolumeContainer/VolumeSlider/Hover.play()
