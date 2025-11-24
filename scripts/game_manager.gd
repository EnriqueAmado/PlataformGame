extends Node
var coins = 0
var score = 0

func playSoundFx(stream):
	$SoundFx.stream = stream
	$SoundFx.play()
	

func _process(delta : float) -> void:
	$"GUI/CoinsValue".text = str(coins)
	$"GUI/ScoreValue".text = str(score)
	
func reset_level():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for e in enemies:
		if e.has_method("reset"):
			e.reset()

# Botón "Continuar"
func _on_ContinueButton_pressed():
	GameManager.continue_game()


# Botón "Nueva Partida"
func _on_NewGameButton_pressed():
	# Borra la partida anterior si quieres
	var save = ConfigFile.new()
	save.save("user://savegame.cfg")  # esto vacía el archivo
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


# Botón "Salir"
func _on_QuitButton_pressed():
	get_tree().quit()
	
func save_game(player_position: Vector2, current_level: String):
	var save = ConfigFile.new()
	save.set_value("player", "position_x", player_position.x)
	save.set_value("player", "position_y", player_position.y)
	save.set_value("game", "level", current_level)
	save.save("user://savegame.cfg")

func load_game():
	var save = ConfigFile.new()
	if save.load("user://savegame.cfg") != OK:
		return null
	return {
		"position": Vector2(
			save.get_value("player", "position_x", 0),
			save.get_value("player", "position_y", 0)
		),
		"level": save.get_value("game", "level", "res://scenes/level_1.tscn")
	}
