extends RigidBody3D

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
	if Input.is_action_just_pressed("ui_accept"):
		print('Jump')
		#$Tongue.apply_central_impulse(Vector2.DOWN * STRENGTH) 
		apply_impulse(Vector3.UP * IMPULSE_STRENGTH)
		$RigidTongue.apply_impulse(Vector3.DOWN * IMPULSE_STRENGTH)
	elif Input.is_action_pressed("ui_accept"):
		apply_force(Vector3.UP * FORCE_STRENGTH)
		$RigidTongue.apply_force(Vector3.DOWN * FORCE_STRENGTH)
	else:
		pass
