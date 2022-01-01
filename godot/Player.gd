extends KinematicBody2D
signal fire
signal reload

export (int) var speed = 150
export (float) var rotation_speed = 1.5
export (int) var bullet_speed = 800

var velocity = Vector2()
var rotation_dir = 0
var can_fire = true
var bullet_count = 6

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
		fire()
		
	$Sprite/TankBody/Turret.look_at(get_global_mouse_position())

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	if rotation_dir == 0:
		$TankTurningSound.stop()
	else:
		if not $TankTurningSound.playing:
			if velocity == Vector2(0,0):
				$TankTurningSound.volume_db = -20
			else:
				$TankTurningSound.volume_db = -17
			$TankTurningSound.play()
		
	velocity = move_and_slide(velocity)
	if velocity == Vector2(0,0):
		$TankSteadySound.stop()
		$TankStartupSound.stop()
		if not $TankStopSound.playing:
			$TankStopSound.play()
	else:
		if not ($TankStartupSound.playing or $TankSteadySound.playing):
			$TankStopSound.stop()
			$TankStartupSound.play()

func fire():
	if can_fire and bullet_count > 0:
		can_fire = false
		bullet_count -= 1
		emit_signal("fire")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $Sprite/TankBody/Turret.get_global_position() + Vector2(70,0).rotated($Sprite/TankBody/Turret.global_rotation) 
		bullet_instance.rotation = $Sprite/TankBody/Turret.global_rotation
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed, 0).rotated($Sprite/TankBody/Turret.global_rotation))
		get_tree().get_root().add_child(bullet_instance)
		$BulletFire.play()
		$BulletInterval.start()
		if ($BulletReload.time_left <= 0):
			$BulletReload.start()
		


func _on_BulletInterval_timeout():
	can_fire = true


func _on_BulletReload_timeout():
	
	bullet_count += 1
	if bullet_count >= 6:
		$BulletReload.stop()
	emit_signal("reload")


func _on_TankStartupSound_finished():
	$TankSteadySound.play()

func get_bullet_count():
	return bullet_count
