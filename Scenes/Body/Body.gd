extends KinematicBody2D

class_name Body

# Añadir este metodo en physics process de cada enemigo
func check_game_over() -> void:
	if Global.is_game_over:
		Global.queue_free_if_valid(self)
