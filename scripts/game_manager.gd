extends Node

var coins = 0
var score = 0

func playSoundFx(stream):
	$SoundFx.stream = stream
	$SoundFx.play()
	

func _process(delta : float) -> void:
	$"GUI/CoinsValue".text = str(coins)
	$"GUI/ScoreValue".text = str(score)
