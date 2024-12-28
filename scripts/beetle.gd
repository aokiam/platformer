extends CharacterBody2D
const SPEED = 150
const GRAVITY = 300
const FLOOR = Vector2(0,-1)
var direction = 1
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_front: RayCast2D = $RayCastFront
@onready var ray_cast_back: RayCast2D = $RayCastBack
@onready var timer: Timer = $Timer


var is_dead = false

func kill():
	print("explode")
	$explode.play()
	print("exploded")


func _physics_process(delta: float) -> void:
	animated_sprite.flip_v = false
	if is_dead == false:
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite.flip_h = false
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite.flip_h = true
		if not (ray_cast_front.is_colliding() and ray_cast_back.is_colliding()):
			direction = direction * -1
			if direction == -1:
				animated_sprite.flip_h = false
			else:
				animated_sprite.flip_h = true
		velocity.x = SPEED * direction
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()
