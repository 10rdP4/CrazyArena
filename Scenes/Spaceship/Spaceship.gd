extends StaticBody2D

class_name Spaceship


func _ready() -> void:
	pass

func _on_Puerta_body_exited(_body:Node):
	z_index = 5
	if not Global.on_level:
		Global.next_level()
		pass

func _on_Puerta_body_entered(_body:Node):
	z_index = -1
	if not Global.on_level:
		# Reparar la nave
		$AnimatedSprite.frame = Global.current_level + 1

		# Reducir las particulas
		if Global.current_level == 0:
			$Fire_right.stop_emitting()
		elif Global.current_level == 1:
			$Elecricity.stop_emitting()
		elif Global.current_level == 2:
			$Fire_back_left.stop_emitting()
			$Fire_front_left.stop_emitting()
		pass
