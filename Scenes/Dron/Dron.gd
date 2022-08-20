extends Node2D

var deg_var = 22.5

func rotate(deg) -> void:
	deg = int(deg)
	$AnimatedSprite.rotation_degrees = -deg
	var num = int(-deg / 22.5)

	if num % 2 == 0:
		num = num / 2 % 8
	else:
		num = (num + 1 ) / 2 % 8
	
	$AnimatedSprite.frame = num
