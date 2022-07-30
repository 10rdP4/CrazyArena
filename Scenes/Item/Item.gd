extends Area2D

class_name Item

# Añadir item al inventario del jugador
func _on_Item_body_entered(body:Node) -> void:
	var player : Player = null
	if body.name == "Player":
		player = body	
		if player.get_free_inventory_slots() > 0:
			body.add_item_to_inventory(self)
			queue_free()
		#else:
			# Inventario Lleno	
