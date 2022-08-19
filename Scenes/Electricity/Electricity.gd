extends Node2D

class_name Electricity

func stop_emitting() -> void:
	$Particles2D.emitting = false
	$Light2D.enabled = false
	pass