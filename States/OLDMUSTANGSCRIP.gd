extends CharacterBody2D

enum HORSE_STATE { IDLE, WALK }

@export var move_speed : float = 20
@export var idle_time : float = randi_range(4, 12)
@export var walk_time : float = randi_range(2, 6)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state : HORSE_STATE = HORSE_STATE.IDLE

func _ready():
	pick_new_state()
	print(HORSE_STATE)
	print(move_direction)

func _physics_process(delta):
	if(current_state == HORSE_STATE.WALK):
			velocity = move_direction * move_speed
	else:
			velocity = Vector2.ZERO
		
	move_and_collide(velocity * delta)

#Randomly generate a new move direction, the ranges are the x/y values
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1.1, 1.1)
	)
	if(move_direction.x == 0 and move_direction.y == 0):
		select_new_direction()
	
	if(move_direction.x < 0):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false
	elif(move_direction.y > 0 and current_state == HORSE_STATE.WALK):
		state_machine.travel("walk_down")
	elif(move_direction.y < 0 and current_state == HORSE_STATE.WALK):
		state_machine.travel("walk_up")

func pick_new_state():
	# Move between the animation tree states
	if(current_state == HORSE_STATE.IDLE):
		#change into the walk state
		state_machine.travel("walk_right")
		current_state = HORSE_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	
	elif(current_state == HORSE_STATE.WALK):
		#change into the idle state
		state_machine.travel("idle_right")
		current_state = HORSE_STATE.IDLE
		timer.start(idle_time)


func _on_timer_timeout():
	pick_new_state()
