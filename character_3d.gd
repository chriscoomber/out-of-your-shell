extends Node3D

var IMPULSE_STRENGTH = 0.0
var FORCE_STRENGTH = 30.0
var ROTATION_STRENGTH = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var body_to_tongue: Vector3 = ($RigidTongue.position - $Body.position)
	var body_to_tongue_unit: Vector3 = body_to_tongue.normalized()
	if body_to_tongue.length_squared() > 1.0:
		$Body.apply_force(body_to_tongue_unit * FORCE_STRENGTH)
		$RigidTongue.apply_force(-body_to_tongue_unit * FORCE_STRENGTH)
	elif Input.is_action_just_pressed("ui_accept"):
		print('Jump')
		#$Tongue.apply_central_impulse(Vector2.DOWN * STRENGTH) 
		$Body.apply_impulse(-body_to_tongue_unit * IMPULSE_STRENGTH)
		$RigidTongue.apply_impulse(body_to_tongue_unit * IMPULSE_STRENGTH)
	elif Input.is_action_pressed("ui_accept"):
		$Body.apply_force(-body_to_tongue_unit * FORCE_STRENGTH)
		$RigidTongue.apply_force(body_to_tongue_unit * FORCE_STRENGTH)
	else:
		pass
	
