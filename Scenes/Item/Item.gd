extends Area2D

class_name Item

# Añadir item al inventario del jugador
func _on_Item_body_entered(body:Node) -> void:
	if body.name == "Player":
		if Global.player.get_free_inventory_slots() > 0:
			Global.player.add_item_to_inventory(get_caracteristics())
			queue_free()
		#else:
			# Inventario Lleno	

func get_caracteristics():
	return {
		name = self.name,
	}
