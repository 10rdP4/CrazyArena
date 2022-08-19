extends Node2D

class_name Fire

export var amount = 0

func stop_emitting() -> void:
	$Particles2D.emitting = false
	$Light2D.enabled = false
	pass

func reduce_fire(reduce_amount : int) -> void:
	$Particles2D.amount = reduce_amount
	$Particles2D.lifetime = 1


func _ready() -> void:
	$Particles2D.amount = amount
	$Particles2D.emitting = true
