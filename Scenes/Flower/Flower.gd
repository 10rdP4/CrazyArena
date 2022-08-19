extends Light2D

class_name Flower


func _ready() -> void:
	randomize()
	$Sprite.frame = randi() % 4
	pass