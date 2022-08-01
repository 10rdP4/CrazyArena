extends Body

class_name Player

var max_speed := 600
var acceleration := 0.2
var friction := 0.03
var velocity := Vector2()
var direction = Vector2()

var health := 200
var inventory = []
var max_items_inventory := 5
var inventory_length := 0
var current_item_pos := 0

func player_input() -> void:
	direction = Vector2()
	# Movement
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_down'):
		direction.y += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	if Input.is_action_pressed('ui_up'):
		direction.y -= 1
	
	# Inventory
	if Input.is_action_just_released("scroll_up") and current_item_pos < inventory_length - 1:
		current_item_pos = current_item_pos + 1
		set_current_item_label()

	if Input.is_action_just_released("scroll_down") and current_item_pos > 0:
		current_item_pos = current_item_pos - 1
		set_current_item_label()

	if Input.is_action_just_pressed("drop_item"):
		drop_current_item()

func player_movement() -> void:
	if direction.length() > 0:
		# acelerate
		friction = 0.001
		velocity = lerp(velocity, direction.normalized() * max_speed, acceleration)
	else:
		# decelerate
		friction = 0.03
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

	if Global.snap_bodies:
		position = position.round()


#Getters
func get_free_inventory_slots() -> int :
	return max_items_inventory - inventory_length 

func get_current_item():
	return inventory[current_item_pos]

#Setters
func set_current_item_label():
	var hud :HUD = $Camera/HUD
	hud.find_node("Current_Item", true).text = str(current_item_pos) + " -> "+ inventory[current_item_pos]["name"]

func add_item_to_inventory(item: Dictionary) -> void:
	inventory.append(item)
	inventory_length = inventory.size()
	set_current_item_label()

func drop_current_item():
	#inventory.remove(current_item_pos)
	print(inventory)
	print("DROPPING ITEMS NOT IMPLEMENTED YET")

func _physics_process(delta):
	delta = delta
	player_input()
	player_movement()
