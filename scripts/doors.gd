extends Area2D
const FILE_BEGIN = "res://scenes/levels/level"
@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	sprite.play("normal")

func _process(delta: float) -> void:
	if Global.is_key_collected == true:
		sprite.play("gold")
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Global.is_key_collected == true:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() +1
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
		Global.is_key_collected = false
		
		Global.collected_blocks1 = 0
		Global.collected_blocks2 = 0
	#przeniesienie do następnego levela w get tree
