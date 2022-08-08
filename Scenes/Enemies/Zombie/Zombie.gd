extends Enemy

class_name Zombie

var dir_to_player

var damage = 15
var can_attack := true

func zombie_movement() -> void:
	dir_to_player = global_position.direction_to(Global.player.global_position)
	if Global.snap_bodies:
		position = position.round()

func check_collision(delta : float):
	var collision :KinematicCollision2D = move_and_collide(dir_to_player * speed * delta)
	if collision and can_attack:
		var collider_body :Object = collision.collider
		if collider_body is Player:
			collider_body.take_damage(15)
			can_attack = false
			$AttackTimer.start()
			collider_body.take_knockback(dir_to_player, 150)
			

func _physics_process(delta: float) -> void:
	check_game_over()
	zombie_movement()
	check_collision(delta)
	pass

func _ready() -> void:
	health = 500
	speed = 75 
	pass


func _on_AttackTimer_timeout() -> void:
	can_attack= true
	$AttackTimer.stop()
