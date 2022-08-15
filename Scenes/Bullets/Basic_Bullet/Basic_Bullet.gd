extends KinematicBody2D

class_name Basic_Bullet

var bullet_speed := 800.0
var fired_direction: Vector2
var damage := 100
var can_collide := true

func _on_collision(collision: KinematicCollision2D) -> void:
	print("basic_bullet collision")
	var colliding_body: Object = collision.collider
	if colliding_body is Enemy:
		colliding_body.take_damage(damage)
		if colliding_body.get_health() <= 0:
			Global.queue_free_if_valid(colliding_body)


func move_and_collide_bullet(delta: float) -> void:
	var collision: KinematicCollision2D = \
			move_and_collide(fired_direction * bullet_speed * delta)
	
	if collision and can_collide:
		_on_collision(collision)
		can_collide = false
		Global.queue_free_if_valid(self)

	if Global.snap_bullets:
		position = position.round()

# Signal
func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.queue_free_if_valid(self)

func _physics_process(__delta: float) -> void:
	move_and_collide_bullet(__delta)

func _ready() -> void:
	self.rotation_degrees = rad2deg(atan2(fired_direction.y, fired_direction.x))
