extends Control

const PACKED_PLAYER: PackedScene = preload("res://Scenes/Player/Player.tscn")

# Variables
#-----------------------------------------
# Ajusta el cuerpo al pixel mas cercano
var snap_bodies := false
var snap_bullets := false
#-----------------------------------------

var arena: Arena = null
var player: Player = null
var current_bullet: PackedScene = null


# Getters
func get_display_size() -> Vector2:
	var __display_width: int = ProjectSettings.get_setting("display/window/size/width")
	var __display_height: int = ProjectSettings.get_setting("display/window/size/height")
	return Vector2(__display_width, __display_height)


# Funciones
func spawn_player() -> void:
	player = PACKED_PLAYER.instance()
	player.global_position = get_display_size()/2 # - player.get_size()/2
	arena.add_child(player, true)

func change_current_bullet(bullet_type: String) -> void:
	current_bullet = load("res://Scenes/Bullets/" + bullet_type + "/" + bullet_type + ".tscn")

func shoot_bullet(direction: Vector2) -> void:
	var bullet := current_bullet.instance()
	bullet.fired_direction = direction
	bullet.position = player.get_shoot_point()
	arena.add_child(bullet, true)

func is_valid_node(node: Node) -> bool:
	if !node:
		return false
	if !is_instance_valid(node):
		return false
	if node.is_queued_for_deletion():
		return false
	return true

func queue_free_if_valid(node: Node) -> void:
	if is_valid_node(node):
		node.queue_free()

func init_nodes( __arena : Node ) -> void:
	arena = __arena

func start_game() -> void:
	spawn_player()
