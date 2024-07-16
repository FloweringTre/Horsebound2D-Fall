extends State
class_name MustangRun

@export var mustang: CharacterBody2D
@export var move_speed := 40.0
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(delta: float):
	var direction = mustang.global_position - player.global_position
	
	if direction.length() > 5:
		mustang.velocity = direction.normalized() * move_speed
	else:
		mustang.velocity = Vector2()
	
