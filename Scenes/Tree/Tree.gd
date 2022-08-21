extends StaticBody2D

class_name Red_Tree

func _ready() -> void:
	randomize()
	$Sprite.frame = randi() % 2
	randomize()
	$Sprite.flip_h = (randi() % 50) % 2 == 0 
	pass