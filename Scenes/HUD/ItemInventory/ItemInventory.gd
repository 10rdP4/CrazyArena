extends Control

class_name ItemInventory

func change_icon(path: String) -> void:
	$Item.texture = load(path)
	pass

func change_border(current : bool) -> void:
	if current:
		$Border.animation = "Selected"
	else:
		$Border.animation = "Normal"
	pass 