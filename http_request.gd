extends HTTPRequest

var API_URL = "https://tu-api.com/score"

@onready var http := HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	
func send_score(player_name: String, score: int):
	var json_data = {
		"name": player_name,
		"score": score
	}

	var body = JSON.stringify(json_data)
	var headers = ["Content-Type: application/json"]

	http.request(API_URL, headers, HTTPClient.METHOD_POST, body)
	print("Enviando puntuación...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_scores():
	http.request(API_URL, [], HTTPClient.METHOD_GET)
	print("Solicitando scoreboard...")

func _on_request_completed(result, response_code, headers, body):
	print("Código de respuesta:", response_code)

	var text = body.get_string_from_utf8()

	var data
	var error = OK

	# Intentamos convertir JSON
	if text != "":
		data = JSON.parse_string(text)
		if typeof(data) != TYPE_DICTIONARY and typeof(data) != TYPE_ARRAY:
			print("Error: respuesta JSON no válida")
			return

	# -------------------------
	# SI ES PETICIÓN GET:
	# -------------------------
	if response_code == 200 and typeof(data) == TYPE_ARRAY:
		print("--- SCOREBOARD ---")
		for entry in data:
			print(entry["name"], " → ", entry["score"])

	# -------------------------
	# SI ES PETICIÓN POST:
	# -------------------------
	if response_code == 201:
		print("Puntuación enviada correctamente.")
