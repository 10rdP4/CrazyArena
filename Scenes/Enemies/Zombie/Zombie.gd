extends Enemy

class_name Zombie

var dir_to_player

var damage = 15
var knockback = 150
var can_attack := true

func zombie_movement() -> void:
	dir_to_player = global_position.direction_to(Global.player.global_position)
	if Global.snap_bodies:
		position = position.round()
	move_and_slide(dir_to_player * speed)

func check_collision():
	var collision :KinematicCollision2D = get_last_slide_collision()
	if collision and can_attack:
		var collider_body :Object = collision.collider
		if collider_body is Player:
			collider_body.take_damage(damage)
			can_attack = false
			$AttackTimer.start()
			collider_body.take_knockback(dir_to_player, knockback)
			

func _physics_process(_delta: float) -> void:
	check_game_over()
	zombie_movement()
	check_collision()
	pass

func _ready() -> void:
	health = 500
	speed = 175 
	pass


func _on_AttackTimer_timeout() -> void:
	can_attack= true
	$AttackTimer.stop()
