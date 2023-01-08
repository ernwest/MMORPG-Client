extends Node

class_name Avatar

var player_name: 		String

var player_class: 		int
var player_race: 		int
var combat_state:		int
var move_state:			int
var fraction:			int

var items_inventory: 	Array
var buffs: 				Array

var items_equipped: 	Dictionary
var features: 			Dictionary

var position:			Vector3

enum PLAYER_STATE {
	PEACE
	COMBAT
	COMBAT_PVP
}

enum PLAYER_FRACTION {
	FIRE
	SAND
	SHADOW
	ADMIN
}

enum PLAYER_CLASS {
	WARRIOR
	MAGE
	SHAMAN
	HEALER
	SUMMONER
	ROGUE
	SAMURAI
	ARCHER
	ADMIN
}

enum PLAYER_RACE {
	HUMAN
	ELF
	ORC
	TWINS
	ADMIN
}

enum MOVE_STATE {
	IDLE
	MOVE_FORWARD
	MOVE_BACKWARD
	MOVE_SIDEWARD
	JUMP
}

func _init(_player_name: String, _fraction: int = PLAYER_FRACTION.ADMIN, _player_class: int = PLAYER_CLASS.ADMIN, _player_race: int = PLAYER_RACE.ADMIN):
	player_name  		= 	_player_name
	fraction 	 		= 	_fraction
	player_class 		= 	_player_class
	player_race	 		= 	_player_race
	
	combat_state 		= 	PLAYER_STATE.PEACE
	move_state	 		= 	MOVE_STATE.IDLE
	
	position	 		= 	Vector3(0, 5, 0)
	
	features = {
		speed_increase  = 1
	}

func get_feature(feat: String):
	return features[feat]










