extends Node2D

var character_selected_name: String = ""
var character_selected_player: PackedScene = null

func button_click():
	$Click.play()

func button_hover():
	$Hover.play()
	
func step_play():
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randi_range(1, 3)
	if my_random_number == 1:
		$Step1.play()
	elif my_random_number == 2:
		$Step2.play()
	else:
		$Step3.play()

func set_selected_character_data(name: String, player: PackedScene):
	character_selected_name = name
	character_selected_player = player
