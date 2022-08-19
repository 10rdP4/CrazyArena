extends Node2D

class_name Arena

func _ready() -> void:
	Global.init_arena(self)

func get_spwn_pos(type : String) -> Vector2:
	var spwn = find_node(type + "Spwn")
	spwn.offset = randi()
	return spwn.position

func _on_Oleada_timeout():
	Global.spawn_enemies()