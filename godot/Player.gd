extends KinematicBody2D

export (int) var speed = 150
export (float) var rotation_speed = 1.5
export (int) var bullet_speed = 800

var velocity = Vector2()
var rotation_dir = 0
var can_fire = true
var fire_delay = .3

var bullet = preload("res://Bullet.tscn")

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
	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()
		print($Sprite/TankBody/Turret.global_rotation)
		print(global_rotation)
		bullet_instance.position = $Sprite/TankBody/Turret.get_global_position() + Vector2(70,0).rotated($Sprite/TankBody/Turret.global_rotation) 
		bullet_instance.rotation = $Sprite/TankBody/Turret.global_rotation
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed, 0).rotated($Sprite/TankBody/Turret.global_rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_delay), "timeout")
		can_fire = true
		
	$Sprite/TankBody/Turret.look_at(get_global_mouse_position())

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
