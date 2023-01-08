extends KinematicBody

onready var animation   = $AnimationPlayer
onready var cam_move 	= $CameraMove
onready var nickname	= $UI/nickname

# Script Variables
var is_mouse_look 		= false
var is_jump				= false
var is_jump_dir			= false

var _vel 				= Vector3.ZERO
var velocity 			= Vector3.ZERO

var speed				= FORWARD_SPEED

var C_ROTATION_MAX 		= 85
var C_ROTATION_MIN 		= -15

onready var camera_pos	= cam_move.get_child(0).translation

var t 					= 0

onready var avatar 		= Avatar.new(Server.client_info.name)

# World Config taken from Server
var GRAVITY             = 98       # Gravity
var FORWARD_SPEED       = 25       # Forward speed for player, npc and mobs
var SIDEWARD_SPEED		= 20	   # Sideward speed for player, npc and mobs
var BACKWARD_SPEED      = 10	   # Backward speed for player, npc and mobs
var JUMP_FORCE          = 30	   # Player jump force
var JUMP_COOLDOWN		= 1		   # Jump cooldown in seconds
var MAX_CAMERA_DIST		= 20
var MIN_CAMERA_DIST		= 0
# ---

# Player Setting
var CameraSpeed: int 	= 300
var _interp: int		= 7
var hide_nickname		= false
# ---
		
var ANIMATION = {
	IDLE 				= 	'idle',
	MOVE_FORWARD		=	'Run',
	MOVE_BACKWARD		=	'Run',
	MOVE_SIDEWARD		=	'Run',
	JUMP 				= 	'Jump'
}

func _ready():
	if hide_nickname: 
		nickname.hide()
	else:
		nickname.text = Server.client_info.name

func _process(delta):
	character_input()
	player_anim_state()	
	t = delta
	cam_move.get_child(0).translation = cam_move.get_child(0).translation.linear_interpolate(camera_pos, delta*_interp)
		
## 60 per second
func _physics_process(delta):
	speed = FORWARD_SPEED
	if avatar.move_state == avatar.MOVE_STATE.MOVE_BACKWARD: speed = BACKWARD_SPEED
	_vel = _vel.normalized()
	velocity.x  = _vel.x * avatar.get_feature('speed_increase') * speed
	velocity.z  = _vel.z * avatar.get_feature('speed_increase') * speed
	velocity.y  = velocity.y - GRAVITY * delta  + _vel.y * JUMP_FORCE
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), true)
	
# Camera Move
func _input(event):
	if Input.is_action_pressed("MOUSELB"):
		if event is InputEventMouseMotion and (event.relative.x != 0 or event.relative.y != 0):
			cameraLook(event)
			is_mouse_look = true
	if Input.is_action_just_released("MOUSELB"):
		is_mouse_look = false
	
	if Input.is_action_pressed("MOUSERB"):
		if event is InputEventMouseMotion and (event.relative.x != 0 or event.relative.y != 0):
			cameraLook(event)
			rotation.y += cam_move.rotation.y
			cam_move.rotation.y = 0
			is_mouse_look = true
	if Input.is_action_just_released("MOUSERB"):
		is_mouse_look = false
		
	if Input.is_action_pressed("MWHEELDOWN") and cam_move.get_child(0).translation.z > -MAX_CAMERA_DIST:
		camera_pos.z -= 1
	elif Input.is_action_pressed("MWHEELUP") and cam_move.get_child(0).translation.z < MIN_CAMERA_DIST:
		camera_pos.z += 1
	
	if is_mouse_look:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func character_input():
	_vel = Vector3.ZERO
	if is_on_floor():
		is_jump 	= false; 
		is_jump_dir = false
		
	if !is_jump or is_jump_dir:
		is_jump_dir = true
		if Input.is_action_pressed("KEY_W"): 
			_vel.z += 1
		if Input.is_action_pressed("KEY_S"): 
			_vel.z -= 1
		if Input.is_action_pressed("KEY_A"): 
			_vel.x += 1
		if Input.is_action_pressed("KEY_D"): 
			_vel.x -= 1
				
#		if Input.is_action_pressed("KEY_A") and Input.is_action_pressed("KEY_D"): _vel.x = 0
#		if Input.is_action_pressed("KEY_W") and Input.is_action_pressed("KEY_S"): _vel.z = 0

	if Input.is_action_pressed("KEY_SPACE") and is_on_floor():
		_vel.y  = 1
		is_jump = true
		
	if _vel.y == 1 or !is_on_floor():
		avatar.move_state = avatar.MOVE_STATE.JUMP
	elif _vel.x != 0 or _vel.z != 0:
		avatar.move_state = avatar.MOVE_STATE.MOVE_FORWARD
	else:
		avatar.move_state = avatar.MOVE_STATE.IDLE
	
	
func cameraLook(event):
	if event.relative.x != 0:
		var camera_speed_global = Vector3(0, -event.relative.x, 0).normalized()
		cam_move.global_rotate(camera_speed_global, CameraSpeed*abs(event.relative.x)*t/100)
	if event.relative.y != 0:
		var camera_speed_local = Vector3(event.relative.y, 0, 0).normalized()
		cam_move.rotate_object_local(camera_speed_local, CameraSpeed*abs(event.relative.y)*t/200)
	cam_move.rotation_degrees.x = clamp(cam_move.rotation_degrees.x, C_ROTATION_MIN, C_ROTATION_MAX)
	cam_move.orthonormalize()
	
	
func player_anim_state():
	match avatar.move_state:
		avatar.MOVE_STATE.IDLE:
			animation.play(ANIMATION.IDLE)
		avatar.MOVE_STATE.MOVE_FORWARD:
			animation.play(ANIMATION.MOVE_FORWARD)
		avatar.MOVE_STATE.MOVE_BACKWARD:
			animation.play(ANIMATION.MOVE_BACKWARD)
		avatar.MOVE_STATE.JUMP:
			animation.play(ANIMATION.JUMP)








