extends Spatial

onready var ray = $RayCast

func shoot():
	if Input.is_action_pressed("shoot"):
		if ray.is_colliding():
			print("Raycast works")
