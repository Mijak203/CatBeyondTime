extends Control

@onready var block_scene: PackedScene = preload("res://scenes/block_1.tscn")

@onready var choser: Sprite2D = $choser #that frame to chose right block in build menu
@onready var marker_1: Marker2D = $marker1
@onready var marker_2: Marker2D = $marker2 

var is_gui_open = false
var block_number = 1 #define what block is chose to build
var chosed_block = 1


func _ready() -> void:
	choser.global_position = marker_1.global_position - Vector2(32,0)
	close()
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("build"):
		chosed_block += 1
		if is_gui_open == true: 
			close()
		else:
			open()
	if is_gui_open == true:
		if Global.available_to_move_blocks == false:
			if Input.is_action_just_pressed("left") and block_number > 1:
				block_number = block_number - 1
				choser.global_position = marker_1.global_position - Vector2(32,0)
			elif Input.is_action_just_pressed("right") and block_number < 2:
				block_number = block_number + 1
				choser.global_position = marker_2.global_position - Vector2(32,0)
			elif Input.is_action_just_pressed("apply"):
				if block_number == 1:
					add_child(block_scene.instantiate())
					Global.available_to_move_blocks = true
				elif block_number == 2: #Normalnie tutaj będą się respiły 2 klocki
					add_child(block_scene.instantiate())
					Global.available_to_move_blocks = true
	
	
	"""
	if is_gui_open == true and Global.available_to_place == false:
		if Input.is_action_just_pressed("left") and block_number > 0:
			block_number -= 1
			choser.global_position = marker_1.global_position - Vector2(32,0)
		if Input.is_action_just_pressed("right") and block_number < 1:
			block_number += 1
			choser.global_position = marker_2.global_position - Vector2(32,0)
		if Input.is_action_just_pressed("apply"):
			if block_number == 0:
				block_place.emit()
				Global.available_to_place = true
			elif block_number == 1:
				block_place.emit()
				Global.available_to_place = true
	elif Input.is_action_just_pressed("apply"):
		Global.available_to_place = false
	"""
	
	
func open():
	is_gui_open = true
	choser.show()
	
func close():
	is_gui_open = false
	choser.hide()
	
