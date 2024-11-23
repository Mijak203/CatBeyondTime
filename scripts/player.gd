extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY_Y = -180
const JUMP_VELOCITY_X = 350
const BASE_GRAVITY = 800
const PUSH_FORCE = 50
const BLOCK_MAX_VELOCITY = 100
@onready var timer1: Timer = $Timer
var temp_counter_for_timer = 0 #timer wykonuje sie raz
var timer_done = false 

var is_note_open = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_detect: RayCast2D = $WallDetect
@onready var edge_detect: RayCast2D = $EdgeDetect
@onready var animation: AnimationPlayer = $AnimationPlayer

enum state{
	IDLE,
	ROTATE,
	RUN,
	JUMP,
	WALL_JUMP
}

var current_state = state.IDLE
var input_direction_x = 0
var counter = 0


func _physics_process(delta: float) -> void:
	if Global.build_mode == false and Global.pause == false:
		phisic()
		
		match(current_state):
			state.IDLE:
				idle(delta)
				
			state.ROTATE:
				rotateing()
				
			state.RUN:
				run(delta)
				
			state.JUMP:
				jump(delta)
				
			state.WALL_JUMP:
				wall_jump()
				
		move_and_slide()
	else:
		move_and_slide()
		state.IDLE
		if is_on_floor():
			velocity.x = 0
		else:
			velocity.y += 5

func phisic():
	input_direction_x = Input.get_axis("go_left", "go_right")
	if input_direction_x != 0:
			temp_counter_for_timer = 0
			timer_done = false
			timer1.one_shot = false
	if input_direction_x == 1:
		wall_detect.target_position =  Vector2(13 , 0)
		wall_detect.force_raycast_update()
		edge_detect.target_position =  Vector2(14 , 0)
		edge_detect.force_raycast_update()
	elif input_direction_x == -1:
		wall_detect.target_position = Vector2(-13 , 0)
		wall_detect.force_raycast_update()
		edge_detect.target_position =  Vector2(-14 , 0)
		edge_detect.force_raycast_update()
	if is_on_floor():
		if Global.note_to_open == true and is_note_open == false and Input.is_action_just_pressed("note"):
			Global.showNote = true
			is_note_open = true
			Engine.time_scale = 0 
		elif Global.note_to_open == true and is_note_open == true and Input.is_action_just_pressed("note"): 
			Global.showNote = false
			is_note_open = false
			Engine.time_scale = 1

func idle(delta):
	velocity.x = 0.0
	velocity.y += BASE_GRAVITY * delta
	if timer_done == false:
		animation.play("idle")
	temp_counter_for_timer+=1
	timer1.one_shot = true
	if temp_counter_for_timer == 1:
		
		timer1.start()
	
	if (input_direction_x == 1 and sprite.flip_h == true):
		current_state = state.ROTATE
	elif (input_direction_x == 1 and sprite.flip_h == false):
		current_state = state.RUN
	elif (input_direction_x == -1 and sprite.flip_h == false):
		current_state = state.ROTATE
	elif (input_direction_x == -1 and sprite.flip_h == true):
		current_state = state.RUN
	elif (Input.is_action_just_pressed("jump")):
		current_state = state.JUMP
	elif wall_detect.is_colliding() and input_direction_x != 0:
		current_state = state.WALL_JUMP
		
func rotateing():
	var rotating = true
	velocity.x = 0.0
	animation.play("rotate")
	
	if sprite.flip_h == true:
		
		await get_tree().create_timer(0.2).timeout
		sprite.flip_h = false
		
	elif sprite.flip_h == false:
		
		await get_tree().create_timer(0.2).timeout
		sprite.flip_h = true
	
	rotating = false
	
	if rotating == false:
		if (input_direction_x == 1 and sprite.flip_h == false): 
			current_state = state.RUN
		elif (input_direction_x == -1 and sprite.flip_h == true):
			current_state = state.RUN
		elif (input_direction_x == 0):
			current_state = state.IDLE
			
func run(delta):
	velocity.x = SPEED * input_direction_x
	velocity.y += BASE_GRAVITY * delta
	
	animation.play("run")
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_block = collision.get_collider()
		if collision_block.is_in_group("tables") and abs(collision_block.get_linear_velocity().x) < BLOCK_MAX_VELOCITY:
			collision_block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
	
	if (input_direction_x == 1 and sprite.flip_h == true): 
		current_state = state.ROTATE
	elif (input_direction_x == -1 and sprite.flip_h == false):
		current_state = state.ROTATE
	elif (input_direction_x == 0):
		current_state = state.IDLE
	elif (Input.is_action_pressed("jump")):
		current_state = state.JUMP
	elif wall_detect.is_colliding() and input_direction_x != 0:
		current_state = state.WALL_JUMP
		
func jump(delta):
	counter += 1
	velocity.y += BASE_GRAVITY * delta
	
	animation.play("jump")
	
	if counter == 1:
		velocity.x = 0
		velocity.y = JUMP_VELOCITY_Y
		if sprite.flip_h == false:
			velocity.x = lerp(float(JUMP_VELOCITY_X), 0.0, 0.7)
		else:
			velocity.x = lerp(float(-JUMP_VELOCITY_X), 0.0, 0.7)
		await get_tree().create_timer(0.5).timeout
		counter = 0
		current_state = state.IDLE

func wall_jump():
	animation.play("jumpOnEdge")
	if !edge_detect.is_colliding():
		counter +=1
		if counter == 1:
			if sprite.flip_h == false:
				velocity.x += 15
				velocity.y = -110
				counter = 0
			if sprite.flip_h == true:
				velocity.x -= 15
				velocity.y = -110
				counter = 0
		await get_tree().create_timer(0.3).timeout
		current_state = state.IDLE
	else:
		velocity.x = 0
		current_state = state.IDLE


func _on_timer_timeout() -> void:
	timer_done = true

	animation.play("getDown")
	await get_tree().create_timer(1).timeout
	animation.play("lay")
	await get_tree().create_timer(1).timeout
	
