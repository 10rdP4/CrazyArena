extends Basic_Bullet

class_name Blue_Bullet

func _on_collision(collision: KinematicCollision2D) -> void:
	var colliding_body: Object = collision.collider
	if colliding_body is Enemy:
		colliding_body.take_damage(damage)
		colliding_body.modulate = Color.blue
		Global.queue_free_if_valid(self)
	pass

func _physics_process(delta: float) -> void:
	move_and_collide_bullet(delta)

func _ready() -> void:
	damage = 150