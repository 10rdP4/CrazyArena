extends Control

class_name HUD

const PACKED_INVENTORY_ITEM: PackedScene = preload("res://Scenes/HUD/ItemInventory/ItemInventory.tscn")

var inventory:HBoxContainer = null
var inventory_items = []

func update_item_icon() -> void:
	for i in Global.player.max_items_inventory:
		inventory_items[i].change_icon(Global.player.inventory[i]["icon"])
	pass

func update_current_item_border() -> void:
	for i in Global.player.max_items_inventory:
		inventory_items[i].change_border(i == Global.player.current_item_pos)
	pass

func update_inventory() -> void:
	update_current_item_border()
	update_item_icon()

func _ready() -> void:
	inventory = find_node("Inventory")
	for i in Global.player.max_items_inventory:
		var item :ItemInventory= PACKED_INVENTORY_ITEM.instance()
		inventory.add_child(item)
		inventory_items.push_back(item)
