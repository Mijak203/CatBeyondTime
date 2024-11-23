extends Node2D

func _process(delta: float) -> void:
	await get_tree().create_timer(12).timeout
	get_tree().change_scene_to_file("res://scenes/instruction.tscn")
	
