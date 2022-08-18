extends Node

onready var item_database:Dictionary = GlobalDataParser.load_data("res://Database/Items_db.json")

func get_item_by_id(i_type: String, i_id: int) -> Dictionary:
	var item =  item_database.get(i_type)[i_id]
	if item == null :
		return {}
	return item 

func get_item_by_name(i_type: String, i_name: String):
	for i in item_database.get(i_type):
		return i if i["name"] == i_name else  {}

# Devuelve la lista de items de un tipo
func get_item_list_by_type(i_type: String) -> Array:
	return item_database.get(i_type)

func get_item_type_list() -> Array:
	return item_database.keys()
