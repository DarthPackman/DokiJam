extends Node2D

var character_selected_name: String = ""
var character_selected_player: PackedScene = null

func button_click():
	$ClickASP.play()

func button_hover():
	$CursorASP.play()
	
func button_back():
	$BackASP.play()
	
func button_confirm():
	$ConfirmASP.play()

func set_selected_character_data(name: String, player: PackedScene):
	character_selected_name = name
	character_selected_player = player
