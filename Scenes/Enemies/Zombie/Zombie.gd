extends Enemy

class_name Zombie

var dir_to_player

var damage = 15

func zombie_movement() -> void:
	dir_to_player = global_position.direction_to(Global.player.global_position)
		
	move_and_slide(dir_to_player * speed)

	check_collision()

	if Global.snap_bodies:
		position = position.round()

func check_collision():
	var collision :KinematicCollision2D = move_and_collide(Vector2.ZERO, true, true, true)
	if collision:
		var collider_body :Object = collision.collider
		if collider_body is Player:
			collider_body.take_damage(15)
			collider_body.take_knockback(dir_to_player, 150)
			

func _physics_process(delta: float) -> void:
	zombie_movement()
	pass

func _ready() -> void:
	health = 500
	speed = 75 
	pass
