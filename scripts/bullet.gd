extends Area2D

var speed = 500
var direction = 1
@onready var timer: Timer = $Timer
var beetle_scene = preload("res://scenes/beetle.tscn")

func set_bullet_direction(dir):
	direction = dir
	if dir == -1:
		$Bullet.flip_h = true

func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "beetle" in body.name:
		body.velocity = Vector2.ZERO
		body.call_deferred("queue_free")
	queue_free()
