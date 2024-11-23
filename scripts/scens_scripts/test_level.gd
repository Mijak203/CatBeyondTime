extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var label: Label = $Label
@onready var pause_menu: Control = $PauseMenu
var paused = false
var build_mode = false

func _process(delta: float) -> void:
	label.text = str(Global.collected_blocks1)
		
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if Input.is_action_just_pressed("build"):
		buildMenu()
		

func pauseMenu():
	if paused == true:
		pause_menu.hide()
		Engine.time_scale = 1
		Global.eng_stop = false
	else:
		pause_menu.show()
		Engine.time_scale = 0
		Global.eng_stop = true
	
	paused = !paused
	
func buildMenu():
	if build_mode == true:
		Engine.time_scale = 1
		ground.material.set_shader_parameter("s_enable", false)
		Global.eng_stop = false
	else:
		Engine.time_scale = 0.2
		ground.material.set_shader_parameter("s_enable", true)
		Global.eng_stop = true
	
	build_mode = !build_mode
