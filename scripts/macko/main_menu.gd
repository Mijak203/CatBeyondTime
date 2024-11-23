extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/julko/entering_basement.tscn") #Potem cutscenka

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/macko/options_menu.tscn")
