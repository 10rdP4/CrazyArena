extends Node2D

var deg_var = 22.5

var animated_sprite

func rotate(deg) -> void:
	deg = int(deg)
	animated_sprite.rotation_degrees = -deg
	var num = int(-deg / 22.5)

	if num % 2 == 0:
		num = num / 2 % 8
	else:
		num = (num + 1 ) / 2 % 8
	
	animated_sprite.frame = num

func _ready() -> void:
	animated_sprite = find_node("AnimatedSprite")