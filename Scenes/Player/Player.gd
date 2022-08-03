extends Body

class_name Player

var max_speed := 400
var acceleration := 0.2
var friction := 0.03
var velocity := Vector2()
var direction = Vector2()

var health := 200
var inventory = []
var max_items_inventory := 5
var current_item_pos := 0

var empty_item := {
			"id" : -1,
			"type" : "null",
			"name" : "empty",
			"icon" : "res://icon.png",
		}

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
	if Input.is_action_just_released("scroll_up") and current_item_pos < inventory.size() - 1:
		current_item_pos = current_item_pos + 1
		update_current_item()

	if Input.is_action_just_released("scroll_down") and current_item_pos > 0:
		current_item_pos = current_item_pos - 1
		update_current_item()

	if Input.is_action_just_pressed("drop_item"):
		if inventory.size() > 0:
			drop_current_item()

	if Input.is_action_just_pressed("left_click"):
		if inventory.size() > 0:
			item_main_action(get_current_item())

	invert_player_sprite(Global.get_global_mouse_position().x - Global.player.position.x < 0)

func player_movement() -> void:
	if direction.length() > 0:
		# acelerate
		velocity = lerp(velocity, direction.normalized() * max_speed, acceleration)
	else:
		# decelerate
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

	if Global.snap_bodies:
		position = position.round()

func get_shoot_direction() -> Vector2:
	return Global.player.position.direction_to(Global.get_global_mouse_position())

func item_main_action(item: Dictionary) -> void:
	if item["type"] == "weapon":
		Global.shoot_bullet(get_shoot_direction())
	pass

func get_free_inventory_slots() -> int :
	var count_empty_slots = 0
	for item in inventory:
		if item["name"] == "empty":
			count_empty_slots += 1

	return count_empty_slots

func change_weapon_bullet() -> void:
		Global.change_current_bullet(get_current_item()["bullet"])

func change_weapon_visibility():
	if get_current_item()["type"] == "weapon":
		change_weapon_bullet()
		$Weapon/Sprite.texture = load(get_current_item()["icon"])
		$Weapon.visible = true
	else:
		$Weapon.visible = false

func add_item_to_inventory(item: Dictionary) -> void:
	var first_empty_slot = inventory.find(empty_item)
	if first_empty_slot != -1:
		inventory[first_empty_slot] = item
	else:
		inventory.append(item)
	update_current_item()

func invert_player_sprite(invert: bool) -> void:
	$Sprite.flip_h = invert
	$Weapon/Sprite.flip_v = invert

func weapon_point_to_mouse() -> void:
	var rads = Global.player.position.angle_to_point(Global.get_global_mouse_position())
	$Weapon.rotation_degrees = rad2deg(rads) - 180 

func drop_current_item() -> void:
	if get_current_item()["name"] != "empty":
		Global.instance_item(get_current_item())
		inventory[current_item_pos] = empty_item
		update_current_item()

func update_current_item() -> void:
	set_current_item_label()
	change_weapon_visibility()

func get_current_item() -> Dictionary:
	return inventory[current_item_pos]

func get_shoot_point() -> Vector2:
	return $Weapon/shoot_point.global_position

func set_current_item_label() -> void:
	var hud :HUD = $Camera/HUD
	hud.find_node("Current_Item", true).text = str(current_item_pos) + " -> "+ get_current_item()["name"]

func _physics_process(delta):
	delta = delta # esto es solo para que no me salga la advertencia de variable no usada
	player_input()
	player_movement()

	if $Weapon.visible == true:
		weapon_point_to_mouse()

func _ready() -> void:
	for i in max_items_inventory:
		inventory.append(empty_item)
	update_current_item()
