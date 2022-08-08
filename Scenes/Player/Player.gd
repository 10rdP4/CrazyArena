extends Body

class_name Player

var max_speed := 200
var acceleration := 0.2
var friction := 0.06
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

func item_main_action(item: Dictionary) -> void:
	GlobalItemActions.item_main_action(item)

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
		GlobalItemActions.instance_item(get_current_item())
		inventory[current_item_pos] = empty_item
		update_current_item()

func remove_current_item() -> void:
	inventory[current_item_pos] = empty_item
	update_current_item()

func update_current_item() -> void:
	set_current_item_label()
	change_weapon_visibility()

func take_damage(damage : int) -> void:
	health -= damage
	set_current_health_label()
	if health <= 0:
		Global.end_game()

func restore_helth(cure: int) -> void:
	health += cure
	set_current_health_label()

func take_knockback(knockback: Vector2, intensity: float) -> void:
	velocity = knockback * intensity

func get_current_item() -> Dictionary:
	return inventory[current_item_pos]

func get_shoot_point() -> Vector2:
	return $Weapon/shoot_point.global_position

func set_current_item_label() -> void:
	var hud :HUD = $Camera/HUD
	hud.find_node("Current_Item", true).text = str(current_item_pos) + " -> "+ get_current_item()["name"]

func set_current_health_label() -> void:
	var hud :HUD = $Camera/HUD
	hud.find_node("Health_Points", true).text = "HP: " + str(health) 

func _physics_process(_delta):
	check_game_over()
	player_input()
	player_movement()

	if $Weapon.visible == true:
		weapon_point_to_mouse()

func _ready() -> void:
	for i in max_items_inventory:
		inventory.append(empty_item)
	update_current_item()
	set_current_health_label()
