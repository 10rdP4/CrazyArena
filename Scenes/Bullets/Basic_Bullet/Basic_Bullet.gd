extends KinematicBody2D

class_name Basic_Bullet

var bullet_speed := 20.0
var fired_direction: Vector2

func move_and_collide_bullet() -> void:
	var collision: KinematicCollision2D = \
			move_and_collide(fired_direction * bullet_speed)
	
	if collision:
		var colliding_body: Object = collision.collider
		if colliding_body.name == "Enemy":
			Global.queue_free_if_valid(colliding_body)

	if Global.snap_bullets:
		position = position.round()


func _physics_process(__delta: float) -> void:
	move_and_collide_bullet()

# Signal
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _ready() -> void:
	self.rotation_degrees = rad2deg(atan2(fired_direction.y, fired_direction.x))
