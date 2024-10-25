extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const gravity = 900
var looking = 1

const DASH_SPEED = 800
var dashing = false
var can_dash = true

func _physics_process(delta):
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("jump")

	# Saltar
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
		$AnimationPlayer.play("dash")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_axis("left", "right")
	if input_direction != 0:
		looking = input_direction
		
	
		
	if input_direction:
		velocity.x = input_direction * SPEED
		if is_on_floor():
			$AnimationPlayer.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimationPlayer.play("idle")
			
	if dashing:
		velocity.x = looking * DASH_SPEED
			
	# Rotacion
	if input_direction == 1:
		$Sprite2D.flip_h = false
	elif input_direction == -1:
		$Sprite2D.flip_h = true

	if dashing:
		$AnimationPlayer.play("dash")

	move_and_slide()

# Parar el dash
func _on_dash_timer_timeout():
	dashing = false


func _on_dash_again_timer_timeout():
	can_dash = true
