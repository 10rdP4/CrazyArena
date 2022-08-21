extends Body

class_name Player

var max_speed := 200
var acceleration := 0.2
var friction := 0.06
var velocity := Vector2()
var direction = Vector2()
var can_roll := true
var rolling := false


var hud :HUD

var health := 200
var inventory = []
var max_items_inventory := 5
var current_item_pos := 0

var empty_item := {
			"id" : -1,
			"type" : "null",
			"name" : "empty",
			"icon" : "res://Sprites/Items/empty_item.png",
		}

func player_input() -> void:
	direction = Vector2()
	# Movement
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
		invert_player_sprite(false)
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
		invert_player_sprite(true)
	if Input.is_action_pressed('ui_down'):
		direction.y += 1
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
		drop_current_item()
		
	if Input.is_action_just_pressed("left_click"):
		if inventory.size() > 0:
			item_main_action(get_current_item())

	if Input.is_action_pressed("roll"):
		if can_roll:
			player_roll()


func player_movement() -> void:
	if direction.length() > 0:
		# acelerate
		velocity = lerp(velocity, direction.normalized() * max_speed, acceleration)
	else:
		# decelerate
		velocity = lerp(velocity, Vector2.ZERO, friction)
	if !rolling: 
		if get_speed() < 40:
			$Sprite.play("idle")
		else:
			$Sprite.play("walk")
	
	velocity = move_and_slide(velocity)

	if Global.snap_bodies:
		position = position.round()

func player_roll() -> void:
	max_speed = 400
	can_roll = false
	rolling = true
	$CollisionShape2D.shape.height = 10
	$CollisionShape2D.position.y = 9
	hud.roll_bar_to_zero()
	$RollTimer.start()
	$RollCooldown.start()
	$Sprite.play("roll")

func item_main_action(item: Dictionary) -> void:
	GlobalItemActions.item_main_action(item)

func get_free_inventory_slots() -> int :
	var count_empty_slots = 0
	for item in inventory:
		if item["name"] == "empty":
			count_empty_slots += 1

	return count_empty_slots

func change_weapon_bullet() -> void:
		if get_current_item()["type"] == "weapon":
			Global.change_current_bullet(get_current_item()["bullet"])

func add_item_to_inventory(item: Dictionary) -> void:
	var first_empty_slot = inventory.find(empty_item)
	if first_empty_slot != -1:
		inventory[first_empty_slot] = item
	else:
		inventory.append(item)
	update_current_item()

func invert_player_sprite(invert: bool) -> void:
	$Sprite.flip_h = invert

func weapon_point_to_mouse() -> void:
	var rads = Global.player.position.angle_to_point(Global.get_global_mouse_position())
	var deg =  rad2deg(rads) - 180 
	$Weapon.rotation_degrees = deg

func move_dron() -> void:
	var rads = Global.player.position.angle_to_point(Global.get_global_mouse_position())
	var deg =  rad2deg(rads) - 180 
	$Dron.rotation_degrees = deg
	$Dron.rotate(deg)

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
	change_weapon_bullet()
	find_node("HUD").update_inventory()

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
	return $Dron/shoot_point.global_position

func get_speed() -> float:
	return sqrt(pow(velocity.x,2) + pow(velocity.y,2))

func set_current_item_label() -> void:
	var name = get_current_item()["name"]
	hud.find_node("Current_Item", true).text = name if name != "empty" else ""

func set_current_health_label() -> void:
	hud.find_node("Health_Points", true).text = "HP: " + str(health) 

func _physics_process(_delta):
	check_game_over()
	player_input()
	player_movement()

	if get_current_item()["name"] == "Controler":
		move_dron()

	if not can_roll:
		hud.increase_rollbar($RollCooldown.time_left)

func _ready() -> void:
	for i in max_items_inventory:
		inventory.append(empty_item)
	hud = $Camera/HUD
	update_current_item()
	set_current_health_label()

func _on_RollTimer_timeout() -> void:
	max_speed = 200
	rolling = false
	$CollisionShape2D.shape.height = 29
	$CollisionShape2D.position.y = 0
	$Sprite.play("idle")

func _on_RollCooldown_timeout() -> void:
	can_roll = true
