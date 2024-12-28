extends Node2D

const SPEED = 150
var direction = 1
@onready var ray_cast_left: RayCast2D = $beetle/RayCastLeft
@onready var ray_cast_right: RayCast2D = $beetle/RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $beetle/AnimatedSprite2D
@onready var ray_cast_front: RayCast2D = $beetle/RayCastFront
@onready var ray_cast_back: RayCast2D = $beetle/RayCastBack
@onready var timer: Timer = $Timer
		
		
var is_dead = false

func kill():
	is_dead = true
	position.x = 0
	animated_sprite.flip_v = true
	$beetle/CollisionShape2D.disabled = true
	$beetle/AnimatedSprite2D/killzone/CollisionShape2D.disabled = true
	timer.start()
	
func _process(delta: float) -> void:
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
		position.x += direction * SPEED * delta

func _on_timer_timeout() -> void:
	queue_free()
