extends Control

const PACKED_PLAYER: PackedScene = preload("res://Scenes/Player/Player.tscn")
const PACKED_ITEM: PackedScene = preload("res://Scenes/Item/Item.tscn")

# Variables
#-----------------------------------------
# Ajusta el cuerpo al pixel mas cercano
var snap_bodies := false
var snap_bullets := false
#-----------------------------------------

var is_game_over := false

var hud: HUD = null
var retry_menu = null
var arena: Arena = null
var player: Player = null
var current_bullet: PackedScene = null

# Level variables
var on_level := true
var current_level:= 0
var num_enemies:= 2
var enemies_type = [\
	["Zombie"],\
	["Zombie", "WormBall"],\
	["Zombie", "WormBall"],\
	["Zombie", "WormBall"],\
	["Zombie", "WormBall"]\
]
var on_game_enemies = 0
var max_level = enemies_type.size()


# Getters
func get_display_size() -> Vector2:
	var __display_width: int = ProjectSettings.get_setting("display/window/size/width")
	var __display_height: int = ProjectSettings.get_setting("display/window/size/height")
	return Vector2(__display_width, __display_height)

# Funciones
func change_current_bullet(bullet_type: String) -> void:
	current_bullet = load("res://Scenes/Bullets/" + bullet_type + "/" + bullet_type + ".tscn")

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

func init_arena( __arena : Node ) -> void:
	arena = __arena

func init_retry_menu(retry: Node) -> void:
	retry_menu = retry

# Spawnear el jugador
func spawn_player() -> void:
	player = PACKED_PLAYER.instance()
	player.global_position = Vector2(0, 10)
	arena.add_child(player, true)

func restart_game() ->  void:
	on_level = true
	current_level = 0
	get_tree().reload_current_scene()

# Inicio de Juego
func start_game() -> void:
	is_game_over = false
	spawn_player()

func end_game() -> void:
	retry_menu.visible = true
	is_game_over = true

func _input(__event: InputEvent) -> void:
	if __event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# custom input map for RETRY/QUIT (in Project -> Project Settings -> Input Map [tab])	
	if is_game_over:
		if __event.is_action_pressed("retry"):
			restart_game()
		if __event.is_action_pressed("quit"):
			get_tree().quit()

# MECANICAS DEL JUEGO
func spawn_enemies() -> void:
	for _i in range(num_enemies):
		randomize()
		var enemy_type = enemies_type[current_level][randi() % enemies_type[current_level].size()]
		var enemy_scene = load("res://Scenes/Enemies/" + enemy_type + "/" + enemy_type + ".tscn")
		var enemy = enemy_scene.instance()
		enemy.position = arena.get_spwn_pos(enemy_type)
		arena.add_child(enemy)
		print(enemy_type)
		on_game_enemies += 1

func next_level() -> void:
	if current_level + 1 < max_level:
		print("next level")
		on_level = true
		current_level += 1
		var oleada_timer:Timer = arena.find_node("OleadaTimer")
		oleada_timer.start()
	else:
		print("Fin del juego")
		end_game()

func check_enemies_number() -> void:
	if on_game_enemies <= 0:
		on_level = false
	pass
