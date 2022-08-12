extends Body

class_name Enemy

var health
var speed

func take_damage(damage: int) -> void:
	health = health - damage
	$Sprite.material.set_shader_param("flash_modifier", 0.4)
	$FlashTimer.start()

func get_health() -> int:
	return health

func _on_FlashTimer_timeout() -> void:
	$Sprite.material.set_shader_param("flash_modifier", 0)
	pass # Replace with function body.
