extends CharacterBody2D
class_name Mustang

func _physics_process(delta):
	move_and_slide()
	
	if velocity.length() > 0: 
		$AnimationPlayer.play("walk_right")
		
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
