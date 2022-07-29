extends Body

class_name Player

const max_speed := 600
const acceleration := 0.2

var friction := 0.03

var velocity := Vector2()

func player_movement() -> void:
	# Inputs
    var direction = Vector2()
    if Input.is_action_pressed('ui_right'):
        direction.x += 1
    if Input.is_action_pressed('ui_left'):
        direction.x -= 1
    if Input.is_action_pressed('ui_down'):
        direction.y += 1
    if Input.is_action_pressed('ui_up'):
        direction.y -= 1

	# Movement
    if direction.length() > 0:
		# acelerate
        friction = 0.001
        velocity = lerp(velocity, direction.normalized() * max_speed, acceleration)
    else:
		# decelerate
        friction = 0.03
        velocity = lerp(velocity, Vector2.ZERO, friction)
    velocity = move_and_slide(velocity)

    if Global.snap_bodies:
        position = position.round()


func _physics_process(delta):
    player_movement()