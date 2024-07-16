extends CharacterBody2D

"""
This implements a very rudimentary state machine. There are better implementations
in the AssetLib if you want to make something more complex. Also it shares code with Enemy.gd
and probably both should extend some parent script
"""

@export var WALK_SPEED: int = 100 # pixels per second
@export var ROLL_SPEED: int = 150 # pixels per second
@export var hitpoints: int = 3

var linear_vel = Vector2()
var run_direction = Vector2.DOWN

signal health_changed(current_hp)

@export var facing = "down" # (String, "up", "down", "left", "right")



var anim = ""
var new_anim = ""

enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_RUN, STATE_CROUCH }

var state = STATE_IDLE

# Move the player to the corresponding spawnpoint, if any and connect to the dialog system



func _physics_process(_delta):
	
	## PROCESS STATES
	match state:
		STATE_BLOCKED:
			new_anim = "idle_" + facing
			pass
		STATE_IDLE:
			if (
					Input.is_action_pressed("down") or
					Input.is_action_pressed("left") or
					Input.is_action_pressed("right") or
					Input.is_action_pressed("up")
				):
					state = STATE_WALKING
			if Input.is_action_just_pressed("crouch"):
				state = STATE_CROUCH
				pass
			if Input.is_action_just_pressed("sprint"):
				state = STATE_RUN
				run_direction = Vector2(
						- int( Input.is_action_pressed("left") ) + int( Input.is_action_pressed("right") ),
						-int( Input.is_action_pressed("up") ) + int( Input.is_action_pressed("down") )
					).normalized()
				_update_facing()
			new_anim = "idle_" + facing
			pass
		STATE_WALKING:
			if Input.is_action_just_pressed("attack"):
				state = STATE_ATTACK
			if Input.is_action_just_pressed("sprint"):
				state = STATE_RUN
			
			set_velocity(linear_vel)
			move_and_slide()
			linear_vel = velocity
			
			var target_speed = Vector2()
			
			if Input.is_action_pressed("down"):
				target_speed += Vector2.DOWN
			if Input.is_action_pressed("left"):
				target_speed += Vector2.LEFT
			if Input.is_action_pressed("right"):
				target_speed += Vector2.RIGHT
			if Input.is_action_pressed("up"):
				target_speed += Vector2.UP
			
			target_speed *= WALK_SPEED
			#linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			linear_vel = target_speed
			run_direction = linear_vel.normalized()
			
			_update_facing()
			
			if linear_vel.length() > 5:
				new_anim = "walk_" + facing
			else:
				goto_idle()
			pass
		STATE_ATTACK:
			new_anim = "slash_" + facing
			pass
		STATE_RUN:
			if run_direction == Vector2.ZERO:
				state = STATE_IDLE
			if Input.is_action_just_released("sprint"):
				state = STATE_WALKING
			else:
				set_velocity(linear_vel)
				move_and_slide()
				linear_vel = velocity
				var target_speed = Vector2()
				target_speed = run_direction
				target_speed *= ROLL_SPEED
				#linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
				linear_vel = target_speed
				new_anim = "run_" + facing
		STATE_CROUCH:
			if facing == "up":
				facing = "right"
			if facing == "down":
				facing = "left"	
			new_anim = "kneel_" + facing + "_loop"
			if Input.is_action_just_pressed("crouch"):
				state = STATE_IDLE



	
	## UPDATE ANIMATION
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	pass


func _on_dialog_started():
	state = STATE_BLOCKED

func _on_dialog_ended():
	state = STATE_IDLE


## HELPER FUNCS
func goto_idle():
	linear_vel = Vector2.ZERO
	new_anim = "idle_" + facing
	state = STATE_IDLE


func _update_facing():
	if Input.is_action_pressed("left"):
		facing = "left"
	if Input.is_action_pressed("right"):
		facing = "right"
	if Input.is_action_pressed("up"):
		facing = "up"
	if Input.is_action_pressed("down"):
		facing = "down"




	
