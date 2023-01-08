extends Node

var client 						= NetworkedMultiplayerENet.new()
var server_ip  		 			= "127.0.0.1"
var server_port 				= 7777

var network_created				= false
var is_methods_connected 		= false

var clients 					= {}
var client_info 				= {}

var network_iterator			= 0

var avatar_position

var self_id:					int

func _physics_process(delta):
#	if network_iterator > 60:  network_iterator  = 0
#	else: 					   network_iterator += 1 
#
#	if network_iterator % Engine.iterations_per_second == 0:
	avatar_position = get_tree().get_root().get_node_or_null("World/Avatar")
	if avatar_position == null: return
	avatar_position = avatar_position.global_translation
	Server._update_avatar_position( avatar_position )

func start():
	_on_world_join()

func _on_world_join():
	client.create_client(server_ip, server_port)
	get_tree().network_peer = client
	network_created = true
	
	if is_methods_connected: return
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	is_methods_connected = true

func _connected_ok():
	self_id = get_tree().get_network_unique_id()
	print(self_id)
	get_tree().change_scene("res://Assets/Scenes/World.tscn")
	rpc("register_player", client_info)
	
func _connected_fail():
	print("no connect")
	network_created = false
	client.close_connection()
	get_tree().network_peer = null

#puppet func add_player(id, info):
#	clients[id] = info

puppet func _confirmed_reg():
	pass
	
puppet func _confirm_players_positions(players_position: Dictionary):
	for player in players_position:
		if self_id == player: continue
		if clients.has(player):
#		if !clients.has(player):
#			var new_player  = NetworkPlayer.new()
#			clients[player] = new_player
#			ServerController.create_player(player)
			clients[player].set_position(players_position[player])
	ServerController.draw_players()
	
func _update_avatar_position(pos: Vector3):
	rpc_unreliable("_set_new_pos", pos)
	
puppet func _add_new_player(info, id):
	if clients.has(id): return
	var new_player = NetworkPlayer.new()
	clients[id]    = new_player
	ServerController.create_player(id)
	
	
puppet func _kick_client():
	print("Kicked")
	network_created = false
	client.close_connection()
	get_tree().network_peer = null
	get_tree().change_scene("res://Assets/Scenes/MainMenu/MainMenu.tscn")
	
	
	
	
	
	
	
	
	
	
	
	
