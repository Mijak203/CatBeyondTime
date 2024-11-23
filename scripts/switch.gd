extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var switch_state = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		switch_state = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		switch_state = false

func _process(delta: float) -> void:
	if switch_state == true and Global.build_mode == false:
		if Input.is_action_just_pressed("apply"):
			if Global.switch_state == true:
				Global.switch_state = false
				animation_player.play("off")
			else:
				Global.switch_state = true
				animation_player.play("on")
			
