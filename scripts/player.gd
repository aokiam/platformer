extends CharacterBody2D

const SPEED = 700.0
var jump = 0

const BulletPath = preload("res://scenes/bullet.tscn")
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
		$jump.play()
		velocity.y = jump_velocity
		jump = 1
	timer.start()
	#double jump
	if Input.is_action_just_pressed("jump") and jump == 1 and !is_on_floor():
		$jump.play()
		velocity.y = jump_velocity
		jump = 0
		
	# get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
		if sign($Anchor/Marker2D.position.x) == -1:
			$Anchor/Marker2D.position.x *= -1

	elif direction < 0:
		animated_sprite.flip_h = true
		if sign($Anchor/Marker2D.position.x) == 1:
			$Anchor/Marker2D.position.x *= -1

	
	# play animations
	if is_on_floor():
		if direction == 0:
			if Input.is_action_pressed("shoot"):
				animated_sprite.play("default_gun")
			elif Input.is_action_pressed("crouch"):
				animated_sprite.play("crouch")
			else:
				animated_sprite.play("default")
		else:
			if Input.is_action_pressed("shoot"):
				animated_sprite.play("run_gun")
			else:
				animated_sprite.play("run")
	else:
		if Input.is_action_pressed("shoot"):
			animated_sprite.play("jump_gun")
		else:
			animated_sprite.play("jump")
	
	# move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("shoot"):
		$shoot.play()
		var bullet = BulletPath.instantiate()
		if sign($Anchor/Marker2D.position.x) == 1:
			bullet.set_bullet_direction(1)
		else:
			bullet.set_bullet_direction(-1)
		get_parent().add_child(bullet)
		bullet.position = $Anchor/Marker2D.global_position
			
	move_and_slide()

func _on_timer_timeout() -> void:
	jump = 0
	print(jump)
