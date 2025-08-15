extends Node2D

var character_selected_name: String = ""
var character_selected: PackedScene = null
var default_weapon_name: String = ""

func button_click():
	$ClickASP.play()

func button_hover():
	$CursorASP.play()
	
func button_back():
	$BackASP.play()
	
func button_confirm():
	$ConfirmASP.play()
	
func robot_hit():
	$RobotHitASP.play()
	
func play_menus():
	$MenuMusicASP.play()
	$PlayMusicASP.stop()
	
func play_gameplay():
	$PlayMusicASP.play()
	$MenuMusicASP.stop()
	
func play_step():
	$StepASP.play()

func stop_step():
	$StepASP.stop()

func set_selected_character_data(name: String, player: PackedScene, weapon_name: String):
	character_selected_name = name
	character_selected = player
	default_weapon_name = weapon_name
