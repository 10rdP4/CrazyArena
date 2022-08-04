extends Node

func instance_entity(scene: String) -> void:
	var entity :PackedScene= load(scene)
	var ent = entity.instance()
	ent.position = Global.get_global_mouse_position()
	Global.arena.add_child(ent, true)

func instance_item(_item: Dictionary) -> void:
	var item :Item= Global.PACKED_ITEM.instance()
	item.randomitem = false
	item.set_item_config(_item)
	Global.arena.add_child(item)

func shoot_bullet(direction: Vector2) -> void:
	var bullet := Global.current_bullet.instance()
	bullet.fired_direction = direction
	bullet.position = Global.player.get_shoot_point()
	Global.arena.add_child(bullet, true)

func get_shoot_direction() -> Vector2:
	return Global.player.global_position.direction_to(Global.get_global_mouse_position())

func item_main_action(item: Dictionary) -> void:
	match item["type"]:
		"weapon":
			shoot_bullet(get_shoot_direction())
		"spwn":
			instance_entity(item["entity"])
		_:
			print("Error en el tipo. Global_itemActions.gd")
	pass


