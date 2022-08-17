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
		# spawn nuevo dron
		pass
