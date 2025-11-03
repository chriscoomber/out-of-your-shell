extends RigidBody2D

@onready var body: RigidBody2D = $"../Body"
var anchor_y: float = 50.0

const LIN_IMPULSE_STRENGTH = 0.1
const ANG_IMPULSE_STRENGTH = 10

const LIN_SPRING_STRENGTH = 100.0
const ANG_SPRING_STRENGTH = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var body_state: PhysicsDirectBodyState2D = PhysicsServer2D.body_get_direct_state(body.get_rid())
	var mass_ratio = body_state.inverse_mass / state.inverse_mass
	var inertia_ratio = body_state.inverse_inertia / state.inverse_inertia
	
	# Transfer any forces immediately to the body
	var anchor_normal: Vector2 = Vector2(-cos(body.rotation), -sin(body.rotation)) * anchor_y
	var anchor_lin_vel = body.linear_velocity + anchor_normal * body_state.angular_velocity
	var lin_vel_delta: Vector2 = state.linear_velocity - anchor_lin_vel
	state.apply_central_impulse(-lin_vel_delta / state.inverse_mass)
	body_state.apply_central_impulse(lin_vel_delta / state.inverse_mass)
	
	var ang_vel_delta: float = state.angular_velocity - body_state.angular_velocity
	state.apply_torque_impulse(-ang_vel_delta / state.inverse_inertia)
	body_state.apply_torque_impulse(ang_vel_delta / state.inverse_inertia)
	
	# Stabilize position and angle of the anchor point
	var anchor_position: Vector2 = body.position + Vector2(-sin(body.rotation), cos(body.rotation)) * anchor_y
	print(anchor_position)
	var pos_delta: Vector2 = position - anchor_position
	state.apply_central_force(-pos_delta / state.inverse_mass * LIN_SPRING_STRENGTH)
	body_state.apply_central_force(pos_delta / state.inverse_mass * LIN_SPRING_STRENGTH)
	
	var ang_delta: float = fposmod(rotation - body.rotation + PI, 2*PI) - PI
	state.apply_torque(-ang_delta / state.inverse_inertia * ANG_SPRING_STRENGTH)
	body_state.apply_torque(ang_delta / state.inverse_inertia * ANG_SPRING_STRENGTH)
	
	

	
	pass	
	print(1/state.inverse_inertia)

	#state.linear_velocity = get_node('../Body').linear_velocity
	


func calculate_rotation_difference(a: float, b: float) -> float:
	var answers: Array[float] = [a-b, (a+2*PI)-b, (a-2*PI)-b]
	var answers_abs: Array[float] = []
	answers_abs.assign(answers.map(absf))
	var best_answer_abs = answers_abs.min()
	return answers[answers_abs.find(best_answer_abs)]
