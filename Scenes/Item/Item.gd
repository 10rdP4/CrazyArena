extends Area2D

class_name Item

var item_types  = {
	FOOD = "food",
	WEAPON = "weapon",
	ARMOR = "armor",
	POTION = "potion",
	SPWN = "spwn"
}

export var item_type:String
export var item_id:int
export var randomitem = true
var pickable:bool = true


# Añadir item al inventario del jugador
func _on_Item_body_entered(body:Node) -> void:
	if body.name == "Player" and pickable:
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

	$Icon.texture = load(GlobalItemDatabase.get_item_by_id(item_type, item_id)["icon"])

func set_item_config(item: Dictionary) -> void:
	item_type = item["type"]
	item_id = item["id"]
	pickable = false
	position = Global.player.position
	$Icon.texture = load(GlobalItemDatabase.get_item_by_id(item_type, item_id)["icon"])
		
func _on_Timer_timeout() -> void:
	pickable = true
	pass
			
func _ready() -> void:
	if randomitem:
		random_item_config()
	$Icon.texture = load(GlobalItemDatabase.get_item_by_id(item_type, item_id)["icon"])
