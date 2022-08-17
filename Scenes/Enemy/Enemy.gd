extends Body

class_name Enemy

var health
var speed

func take_damage(damage_taken: int) -> void:
	health = health - damage_taken
	$Sprite.material.set_shader_param("flash_modifier", 0.4)
	$FlashTimer.start()
	if health <= 0:
		dead()

func get_health() -> int:
	return health

func dead() -> void:
	Global.on_game_enemies -= 1
	Global.check_enemies_number()
	queue_free()

func _on_FlashTimer_timeout() -> void:
	$Sprite.material.set_shader_param("flash_modifier", 0)
	pass # Replace with function body.
