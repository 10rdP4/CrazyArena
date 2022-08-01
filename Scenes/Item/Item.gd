extends Area2D

class_name Item

var item_types  = {
	FOOD = "food",
	WEAPON = "weapon",
	ARMOR = "armor"
}

var item_type:String
var item_id:int


# Añadir item al inventario del jugador
func _on_Item_body_entered(body:Node) -> void:
	if body.name == "Player":
		if Global.player.get_free_inventory_slots() > 0:
			Global.player.add_item_to_inventory(GlobalItemDatabase.get_item_by_id(item_type, item_id))
			queue_free()
		#else:
			# Inventario Lleno	

func random_item_config() -> void:
	var item_type_list: Array
	randomize()
	item_type = item_types.get(item_types.keys()[randi() % item_types.size()])
	item_type_list = GlobalItemDatabase.get_item_list_by_type(item_type)
	item_id = randi() % item_type_list.size()

	match item_type:
		item_types.FOOD:
			self.find_node("Icon").modulate = Color.green
		item_types.WEAPON:
			self.find_node("Icon").modulate = Color.blue
		item_types.ARMOR:
			self.find_node("Icon").modulate = Color.gray
			
func _ready() -> void:
	random_item_config()
