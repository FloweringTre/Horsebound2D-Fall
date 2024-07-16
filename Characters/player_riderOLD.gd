extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction: Vector2 = Vector2(0,1)
# parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

#func _ready():
	#update_animation_parameters(starting_direction)

func _physics_process(_delta):
	# get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
#	update_animation_parameters(input_direction)
	
	#update velocity
	velocity = input_direction * move_speed
	
	# move and slide function uses velocity of character body to move character on map
#	pick_new_state()
	move_and_slide()
	
	
#func update_animation_parameters(move_input : Vector2):
	# Dont change animation parameters if there  is no move input
#	if (move_input != Vector2.ZERO):
#		animation_tree.set("parameters/Walk/blend_position", move_input)
#		animation_tree.set("parameters/Idle/blend_position", move_input)
		#animation_tree.set("parameters/Crouch/CrouchDown/blend_position", move_input)
		
		
		
#func pick_new_state():
	# Move between the animation tree states
#	if(velocity != Vector2.ZERO):
#		state_machine.travel("Walk")
#		move_speed = 50
#	if (Input.is_action_pressed("crouch")):
#		state_machine.travel("Crouch")
#		move_speed = 0
#		print("Crouch key enabled")
#	else:
#		state_machine.travel("Idle")
