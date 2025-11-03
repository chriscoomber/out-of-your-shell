extends Node2D

var IMPULSE_STRENGTH = 500.0
var FORCE_STRENGTH = 20000.0
var ROTATION_STRENGTH = 200000.0

var ROTATION_DAMP_STRENGTH = 10000.0
var ROTATION_SPRING_STRENGTH = 100000.0

@onready var body: RigidBody2D = $Body
@onready var rigid_tongue: RigidBody2D = $RigidTongue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	## Angular damping on the tongue to bring it to the same angular velocity as
	## the body
	#var ang_vel_delta = body.angular_velocity - rigid_tongue.angular_velocity
	#rigid_tongue.apply_torque(ang_vel_delta * ROTATION_DAMP_STRENGTH)
	#
	## Torque bringing the tongue back in line with the body
	#var rot_delta = calculate_rotation_difference(body.rotation, rigid_tongue.rotation)
	#rigid_tongue.apply_torque(rot_delta * ROTATION_SPRING_STRENGTH)
	##body.apply_torque(-rot_delta * ROTATION_SPRING_STRENGTH)
#
	var body_to_tongue: Vector2 = (rigid_tongue.position - body.position)
	var body_to_tongue_unit: Vector2 = body_to_tongue.normalized()
	
	
	if Input.is_action_just_pressed("ui_accept"):
		print('Jump')
		#$Tongue.apply_central_impulse(Vector2.DOWN * STRENGTH) 
		$Body.apply_impulse(-body_to_tongue_unit * IMPULSE_STRENGTH)
		$RigidTongue.apply_impulse(body_to_tongue_unit * IMPULSE_STRENGTH)
	elif Input.is_action_pressed("ui_accept"):
		$Body.apply_force(-body_to_tongue_unit * FORCE_STRENGTH)
		$RigidTongue.apply_force(body_to_tongue_unit * FORCE_STRENGTH)
	else:
		pass
		
	#$Tongue.rotation = 0 
		
	var axis = Input.get_axis("ui_left", "ui_right")
	if axis != 0.0:
		$Body.apply_torque(axis * ROTATION_STRENGTH)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func calculate_rotation_difference(a: float, b: float) -> float:
	var answers: Array[float] = [a-b, (a+2*PI)-b, (a-2*PI)-b]
	var answers_abs: Array[float] = []
	answers_abs.assign(answers.map(absf))
	var best_answer_abs = answers_abs.min()
	return answers[answers_abs.find(best_answer_abs)]
