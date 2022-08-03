extends Body

class_name Enemy

var health
var speed

func take_damage(damage: int) -> void:
	health = health - damage
	print(health)

func get_health() -> int:
	return health
