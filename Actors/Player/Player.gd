class_name Player
extends CharacterBody3D

#region EXPORTS
## Horizontal speed
@export_range(.1, 10.) var h_speed := 5.0
## Horizontal deceleration (0 to disable)
@export_range(0., 2.) var h_decel := 0.8
## Jump speed/"strength"
@export_range(.1, 10.) var jump_speed := 4.5
@export_range(.001, .1) var mouse_sensitivity := .02
#endregion

@onready var camera_pivot = %CameraPivot
@onready var camera = %Camera

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Globals.player = self
	mouse_sensitivity *= .1

func _input(event):
	if event is InputEventMouseMotion:
		var ev_rel : Vector2 = -event.relative
		
		rotate_y(ev_rel.x * mouse_sensitivity)
		
		camera_pivot.rotate_x(ev_rel.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -TAU/4., TAU/4.)

func _physics_process(delta):
	var v_speed = velocity.y
	var h_velocity := Vector2(velocity.x, velocity.z)
	
#region VMOVEMENT
	# Add the gravity.
	if not is_on_floor():
		v_speed -= gravity * delta
	# Handle jump.
	elif Input.is_action_just_pressed("jump"):
		v_speed = jump_speed
#endregion

#region HMOVEMENT
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = Utils.transform_hdir(input_dir, transform)
	
	var target_h_vel := Vector2(direction.x, direction.z) * h_speed
	h_velocity = h_velocity.move_toward(target_h_vel, h_decel) if h_decel != 0. else target_h_vel
#endregion

	velocity.x = h_velocity.x
	velocity.y = v_speed
	velocity.z = h_velocity.y
	
	move_and_slide()
