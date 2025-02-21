extends CharacterBody2D
@export var SPEED = 400.0
@export var JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var onfloor = false
var attempt = 1.0

var DEFAULTSPEED = SPEED
var SPEEDMODIFIER = 1.0
var gravityswitch = 1
var playerpos
var oldpos
var isupsidedown
var isdying

func _ready():
	oldpos = Vector2(position.x, position.y)

func _physics_process(delta):
	oldpos = Vector2(position.x, position.y)
	set_up_direction(Vector2(0, gravityswitch * -1))
	if (gravityswitch == -1):
		rotation_degrees = 180
		isupsidedown = true
	else:
		rotation_degrees = 0
		isupsidedown = false
	
	if not is_on_floor():
		velocity.y += (gravity * delta) * gravityswitch
		onfloor = false
	else:
		onfloor = true
	if Input.is_action_just_pressed("player_jump"):
		jumping = true
	if Input.is_action_just_released("player_jump"):
		jumping = false
	# Handle jump.
	if jumping == true and is_on_floor():
		velocity.y = gravityswitch * JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = DEFAULTSPEED * SPEEDMODIFIER
	
	move_and_slide()
	
	playerpos = position
	
	if (oldpos.x == position.x):
		die()

func die():
	position = Vector2(-610,555)
	attempt += 1.0
	# get_node("../Music").stop()
	# get_node("../Music").play(0.0)

func _on_deadlys_body_entered(body):
	print(body)
	if(body.name == "player"):
		die()
