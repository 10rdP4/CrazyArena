extends Enemy

class_name WormBall

var dir_to_player

var damage = 10
var knockback = 150
var can_attack := true
var saved_dir_to_player :Vector2
var rolling := true


func set_walk() -> void:
	$Sprite.animation = "walk"
	$CollisionShape2D.position.y = 12
	$CollisionShape2D.shape.radius = 12
	$CollisionShape2D.shape.height = 56
	speed = 20
	damage = 0
	knockback = 150
	rolling = false
	$Trail.emitting = false

func set_roll() -> void:
	$Sprite.animation = "roll"
	$CollisionShape2D.position.y = 2
	$CollisionShape2D.shape.radius = 27
	$CollisionShape2D.shape.height = 0.01
	speed = 500
	damage = 70
	knockback = 1500
	saved_dir_to_player = dir_to_player
	rolling = true
	$Trail.emitting = true

func invert_sprite() -> void:
	$Sprite.flip_h = dir_to_player.x < 0

func worm_movement() -> void:
	dir_to_player = global_position.direction_to(Global.player.global_position)
	invert_sprite()
	if Global.snap_bodies:
		position = position.round()
	if rolling:
		move_and_slide(saved_dir_to_player * speed)
	else:
		move_and_slide(dir_to_player * speed)

func check_collision() -> void:
	var collision :KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collider_body :Object = collision.collider
		if collider_body is Player:
			collider_body.take_damage(damage)
			collider_body.take_knockback(dir_to_player, knockback)

func take_damage(damage_taken: int) -> void:
	if not rolling:
		health = health - damage_taken
		$Sprite.material.set_shader_param("flash_modifier", 0.4)
		$FlashTimer.start()

func _physics_process(_delta: float) -> void:
	check_game_over()
	worm_movement()
	check_collision()
	pass


func _ready() -> void:
	health = 200
	speed = 20
	set_walk()

func _on_AttackCooldown_timeout():
	$AttackTimer.start()
	set_roll()
	pass # Replace with function body.

func _on_AttackTimer_timeout():
	set_walk()
	pass # Replace with function body.
