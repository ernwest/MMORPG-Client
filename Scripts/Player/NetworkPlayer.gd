# Класс описывающий подключенных игроков по сети

extends Node

class_name NetworkPlayer

var player_name:		String
var prefabname:			String

var position:			Vector3

func _init(_player_name: String = 'unknown', _position: Vector3 = Vector3(0, 5, 0)):
	player_name 		= _player_name
	position			= _position
	
func set_position(new_position: Vector3):
	position 			= new_position
	
func get_position():
	return position
