extends Node2D

@export var level_path: String = "res://scenes/level_1.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/GameManager/GUI".show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var next_level_path: String = "res://scenes/level_2.tscn"
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(next_level_path)
