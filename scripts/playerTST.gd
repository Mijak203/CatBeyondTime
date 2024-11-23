extends CharacterBody2D


const SPEED = 80
const JUMP_VELOCITY_Y = -200
const JUMP_VELOCITY_X = 500

@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_detect: RayCast2D = $WallDetect
@onready var edge_detect: RayCast2D = $EdgeDetect

var jumping = false
var rotating = false
var direction


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY_Y
		if sprite.flip_h == false:
			velocity.x = lerp(float(JUMP_VELOCITY_X), 0.0, 0.7)
		else:
			velocity.x = lerp(float(-JUMP_VELOCITY_X), 0.0, 0.7)
		await get_tree().create_timer(0.5).timeout
		jumping = false

	moving()
	
	if direction and jumping == false and rotating == false and is_on_floor():
		velocity.x = direction * SPEED
	elif !direction and jumping == false and rotating == false:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor():
		if direction == 1:
			wall_detect.target_position =  Vector2(13 , 0)
			wall_detect.force_raycast_update()
		elif direction == -1:
			wall_detect.target_position = Vector2(-13 , 0)
			wall_detect.force_raycast_update()
			
		if wall_detect.is_colliding():
			velocity.y = JUMP_VELOCITY_Y
			await get_tree().create_timer(0.15).timeout
			velocity.x = 400
		
		if direction == 1:
			edge_detect.position = Vector2(11,0)
			edge_detect.force_raycast_update()
		elif direction == -1:
			edge_detect.position = Vector2(-11,0)
			edge_detect.force_raycast_update()
		if !edge_detect.is_colliding() and direction:
			print ("ez")
			
		
		
func moving():
	direction = Input.get_axis("left", "right")
	if is_on_floor():
		if direction == 1 and sprite.flip_h == false and rotating == false:
			rotating = false
			move_and_slide()
		elif direction == 1 and sprite.flip_h == true and rotating == false:
			rotating = true
			await get_tree().create_timer(0.5).timeout
			sprite.flip_h = false 
			rotating = false
		elif direction == -1 and sprite.flip_h == false and rotating == false:
			rotating = true
			await get_tree().create_timer(0.5).timeout
			sprite.flip_h = true
			rotating = false
		elif direction == -1 and sprite.flip_h == true and rotating == false:
			rotating = false
			move_and_slide()
		elif direction == 0 and rotating == false:
			move_and_slide()
	else:
		move_and_slide()
		
