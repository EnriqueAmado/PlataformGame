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
