extends Control

const PACKED_PLAYER: PackedScene = preload("res://Scenes/Player/Player.tscn")

# Variables
#-----------------------------------------
# Ajusta el cuerpo al pixel mas cercano
var snap_bodies := false
#-----------------------------------------

var arena: Arena = null
var player: Player = null


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

func init_nodes( __arena : Node ) -> void:
	arena = __arena

func start_game() -> void:
	spawn_player()
