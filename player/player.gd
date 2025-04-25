extends CharacterBody2D


const SPEED = 200
const GRAVITY = 1000
const JUMP_FORCE = -400

@onready var sprite = $AnimatedSprite2D
var state: State = IdleState.new()

# Base State class (Interface)
class State:
	func handle_input(player: CharacterBody2D, direction: int, is_jumping: bool) -> void:
		pass

# Idle State class
class IdleState extends State:
	#func handle_input(player: CharacterBody2D, direction: int, is_jumping: bool) -> void:
		#if direction != 0:
			#player.state = RunningState.new()
		#elif is_jumping:
			#player.state = JumpingState.new()
			#class IdleState extends State:
	func handle_input(player: CharacterBody2D, direction: int, is_jumping: bool) -> void:
		player.sprite.play("idle")
		if direction != 0:
			player.state = RunningState.new()
		elif is_jumping:
			player.state = JumpingState.new()

# Running State class
class RunningState extends State:
	func handle_input(player: CharacterBody2D, direction: int, is_jumping: bool) -> void:
		if direction == 0:
			player.state = IdleState.new()
		elif is_jumping:
			player.state = JumpingState.new()

# Jumping State class
class JumpingState extends State:
	func handle_input(player: CharacterBody2D, direction: int, is_jumping: bool) -> void:
		if not is_jumping:
			player.state = IdleState.new()

func _ready():
	state = IdleState.new()

func _physics_process(delta):
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1

	var is_jumping = Input.is_action_just_pressed("move_jump") and is_on_floor()

	state.handle_input(self, direction, is_jumping)

	# Flip sprite
	if direction != 0:
		sprite.flip_h = direction < 0

	# Apply horizontal movement
	self.velocity.x = direction * SPEED

	# Apply gravity
	if not is_on_floor():
		self.velocity.y += GRAVITY * delta
	else:
		self.velocity.y = 0

	# Jump
	if is_jumping:
		self.velocity.y = JUMP_FORCE

	# Move the character
	move_and_slide()
