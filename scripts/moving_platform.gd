extends AnimatableBody2D

@onready var colider: RayCast2D = $isColiding

var old_target_position
var moving_speed = 2

func _ready() -> void:
	colider.target_position = Vector2(12,0)
	old_target_position = Vector2(12,0)

func _process(delta: float) -> void:
	if Global.switch_state == true:
		
		position.x += moving_speed
		
		if colider.is_colliding():
			moving_speed *= -1
			
			colider.target_position = colider.target_position * -1
			colider.force_raycast_update()
