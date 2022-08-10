extends Control

class_name HUD

const PACKED_INVENTORY_ITEM: PackedScene = preload("res://Scenes/HUD/ItemInventory/ItemInventory.tscn")

var inventory:HBoxContainer = null
var inventory_items = []
var bar

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

func roll_bar_to_zero() -> void:
	bar.value = 0

func increase_rollbar(time_left) -> void:
	bar.value = (bar.max_value - bar.page) - (time_left * 60)
	pass

func _ready() -> void:
	inventory = find_node("Inventory")
	for i in Global.player.max_items_inventory:
		var item :ItemInventory= PACKED_INVENTORY_ITEM.instance()
		inventory.add_child(item)
		inventory_items.push_back(item)
	bar = find_node("Rollbar")
