extends Node2D

onready var player_name = $Control/Player_Name

func _on_Start_Button_pressed():
	if player_name.text.strip_escapes() == '':
		print("Not allowed")
		return

#	var a = preload("res://Assets/Scenes/World.tscn").instance()
#	get_tree().get_root().get_child(0).hide()
#	get_tree().get_root().add_child(a)
	Server.client_info.name = player_name.text
	Server.start()
	

func _on_Quit_Button_pressed():
	get_tree().quit()
