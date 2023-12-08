class_name Player
extends CharacterBody3D

#region EXPORTS
## Horizontal speed
@export_range(.1, 10., .001) var h_speed := 5.0
## Horizontal deceleration (0 to disable)
@export_range(0., 2., .0001) var h_decel := 0.5
## Jump speed/"strength"
@export_range(.1, 10., .001) var jump_speed := 4.5
#endregion

@onready var camera_pivot = %CameraPivot
@onready var camera = %Camera

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity = 0.002

func _ready():
	Globals.player = self

func _input(event):
	if event is InputEventMouseMotion:
		var ev_rel : Vector2 = -event.relative
		
		rotate_y(ev_rel.x * mouse_sensitivity)
		camera_pivot.rotate_x(ev_rel.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -TAU/4., TAU/4.)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * h_speed
		velocity.z = direction.z * h_speed
	else:
		velocity.x = move_toward(velocity.x, 0, h_decel) if h_decel != 0. else 0.
		velocity.z = move_toward(velocity.z, 0, h_decel) if h_decel != 0. else 0.

	move_and_slide()
