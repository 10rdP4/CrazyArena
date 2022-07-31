extends Node

onready var item_database:Dictionary = GlobalDataParser.load_data("res://Database/Items_db.json")

func get_item(i_type: String, i_id: int) -> Dictionary:
	var item =  item_database.get(i_type)[i_id]
	if item == null :
		return {}
	return item 