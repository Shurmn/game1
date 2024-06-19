extends CharacterBody2D


const SPEED = 200.0
var motion = Vector2()
const JUMP_VELOCITY = -300.0
var direction = Input.get_axis("Move Left", "Move Right")

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction != 0:
		sprite.flip_h = (direction == -1)
	
	update_animations(direction)
	
func update_animations(directions):
	if is_on_floor():
		if velocity.x == 0:
			anim.play("Idle")
		else:
			anim.play("Run")
	else:
		if velocity.y < 0:
			anim.play("Fall")
		elif velocity.y > 0:
			anim.play("Jump")
			
