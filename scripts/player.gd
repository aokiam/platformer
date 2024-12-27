extends CharacterBody2D


const SPEED = 700.0
var jump = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $AnimatedSprite2D/Timer

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

func get_grav() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta: float):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_grav() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump = 1
	timer.start()
	#double jump
	if Input.is_action_just_pressed("jump") and jump == 1 and !is_on_floor():
		velocity.y = jump_velocity
		jump = 0
		
	# get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("default")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout() -> void:
	jump = 0
	print(jump)
