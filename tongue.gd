extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print('Jump')
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("ui_accept"):
		pass
	else:
		velocity.y = -SPEED
		pass
	
	move_and_slide()
	
	position.x = 0.0
	position.y = clampf(position.y, -32.0, 78.0)
