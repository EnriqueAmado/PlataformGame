extends Control
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

# Opcional: si quieres desactivar "Cargar partida" si no hay guardado
func _ready() -> void:
	if GameManager.load_game() == null:
		$LoadButton.disabled = true

# -------------------------------
# Botón Nueva Partida
# -------------------------------
func _on_NewGameButton_pressed() -> void:
	# Borra archivo de guardado
	var save = ConfigFile.new()
	save.save("user://savegame.cfg")
	
	# Cambia al primer nivel
	get_tree().change_scene_to_file("res://scenes/level1.tscn")


# -------------------------------
# Botón Cargar Partida
# -------------------------------
func _on_LoadButton_pressed() -> void:
	var data = GameManager.load_game()
	if data != null:
		get_tree().change_scene_to_file(data["level"])
		
		# Espera a que la escena cargue
		await get_tree().process_frame
		
		# Mueve al jugador a la posición guardada
		var player = get_tree().current_scene.get_node("Player")  # ajusta si tu nodo se llama diferente
		player.global_position = data["position"]


# -------------------------------
# Botón Guardar Partida
# -------------------------------
func _on_SaveButton_pressed() -> void:
	# Obtén la posición del jugador y el nivel actual
	var player = get_tree().current_scene.get_node("Player")
	var current_level = get_tree().current_scene.scene_file_path
	
	GameManager.save_game(player.global_position, current_level)
