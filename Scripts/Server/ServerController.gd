extends Node

var i 						 = 0
var DEFAULT_PLAYER_POSITION := Vector3(0, 5, 0)

# Создает игроков и добавляет их в мир
func create_player(id: int):
	var playerNode = load("res://Assets/Scenes/Avatar.tscn").instance()
	var name = str("Avatar_", i)
	i += 1
	playerNode.translation = DEFAULT_PLAYER_POSITION
	playerNode.set_name(name)
	playerNode.get_node("UI/nickname").text = Server.clients[id].name
	Server.clients[id].prefabname = name
	get_node("/root/").get_child(0).add_child(playerNode)

# Отрисовывает новые данные об игроках
func draw_players():
	for client in Server.clients:
		var player = Server.clients[client]
		var node   = get_node("/root/").get_child(0).get_node(player.prefabname)
		if node == null: return
		node.global_translation = player.position
