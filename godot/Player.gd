extends KinematicBody2D

export (int) var speed = 150
export (float) var rotation_speed = 1.5

var velocity = Vector2()
var rotation_dir = 0

func get_input():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		rotation_dir += 1
	if Input.is_action_pressed("left"):
		rotation_dir -= 1
	if Input.is_action_pressed("back"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
		
	$Sprite/TankBody/Turret.look_at(get_global_mouse_position())

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
