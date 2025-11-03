extends Node3D

const IMPULSE_STRENGTH := 0.0
const EXPAND_FORCE_STRENGTH := 150.0
const CONTRACT_FORCE_STRENGTH := 50.0
const MAX_TORQUE := 30.0
const MAX_ANG_VEL := 20.0
const SPRING_STIFFNESS := 100.0
const SPRING_DAMPENING := 1.0

@onready var body: RigidBody3D = $Body
@onready var head: RigidBody3D = $Head
@onready var generic_6dof_joint_3d: Generic6DOFJoint3D = $Generic6DOFJoint3D
@onready var upper_limit_initial_value := generic_6dof_joint_3d.get_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT)

var head_locked_inside := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var axis := -Input.get_axis("ui_left", "ui_right")
	
	# Apply rotation
	if axis != 0:
		var ang_vel := body.angular_velocity.z
		var rot_factor: float
		if signf(ang_vel) == signf(axis):
			# Trying to accelerate
			rot_factor =  lerpf(MAX_TORQUE, 0, clampf(abs(ang_vel) / MAX_ANG_VEL, 0.0, 1.0))
		else:
			# Trying to brake
			rot_factor = MAX_TORQUE
		print(rot_factor)
		body.apply_torque(Vector3(0.0, 0.0, axis * rot_factor))
	
	var body_to_tongue: Vector3 = (head.position - body.position)
	#var body_to_tongue_unit = body_to_tongue.normalized()
	var groove_direction: Vector3 = body.basis.y
	var groove_direction_unit = groove_direction
	
	# Spring between head and body
	#var spring_force: Vector3 = body_to_tongue.length() * SPRING_STIFFNESS * body_to_tongue_unit
	#var spring_dampening: Vector3 = (body.linear_velocity - head.linear_velocity).length() * SPRING_DAMPENING * body_to_tongue_unit
	#head.apply_central_force(-spring_force)
	#body.apply_central_force(spring_force)
	if Input.is_action_just_pressed("ui_accept"):
		unlock_head()
	elif not Input.is_action_pressed("ui_accept") and body_to_tongue.length_squared() < 0.1:
		lock_head()
		
	#head.apply_central_impulse(body_to_tongue_unit * IMPULSE_STRENGTH)
	#body.apply_central_impulse(-body_to_tongue_unit * IMPULSE_STRENGTH)
	
	if Input.is_action_pressed("ui_accept"):
		head.apply_central_force(groove_direction_unit * EXPAND_FORCE_STRENGTH)
		body.apply_central_force(-groove_direction_unit * EXPAND_FORCE_STRENGTH)
	else:
		head.apply_central_force(-groove_direction_unit * CONTRACT_FORCE_STRENGTH)
		body.apply_central_force(groove_direction_unit * CONTRACT_FORCE_STRENGTH)

	#if body_to_tongue.length_squared() > 1.0:
		#$Body.apply_force(body_to_tongue_unit * FORCE_STRENGTH)
		#$RigidTongue.apply_force(-body_to_tongue_unit * FORCE_STRENGTH)
	#elif Input.is_action_just_pressed("ui_accept"):
		#print('Jump')
		##$Tongue.apply_central_impulse(Vector2.DOWN * STRENGTH) 
		#$Body.apply_impulse(-body_to_tongue_unit * IMPULSE_STRENGTH)
		#$RigidTongue.apply_impulse(body_to_tongue_unit * IMPULSE_STRENGTH)
	#elif Input.is_action_pressed("ui_accept"):
		#$Body.apply_force(-body_to_tongue_unit * FORCE_STRENGTH)
		#$RigidTongue.apply_force(body_to_tongue_unit * FORCE_STRENGTH)
	#else:
		#pass
	#

func lock_head():
	if head_locked_inside:
		return
	head_locked_inside = true
	print("locking head")
	generic_6dof_joint_3d.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, 0.0)

func unlock_head():
	if not head_locked_inside:
		return
	head_locked_inside = false
	print("unlocking head")
	generic_6dof_joint_3d.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, upper_limit_initial_value)
