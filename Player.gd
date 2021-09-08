extends KinematicBody

export var mouse_sensitivity: float = 0.2
export var speed: float = 5
export var max_speed: float = 15
export var jump_force: float = 5
export var gravity_acceleration: float = 12

onready var look = $LookPiviot

var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1 * event.relative.x * mouse_sensitivity))
		look.rotate_x(deg2rad(event.relative.y) * mouse_sensitivity)
		look.rotation.x = clamp(look.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	input_move = get_dir() * speed
	if not is_on_floor():
		print("Player is not on floor")
		gravity_local += gravity_acceleration * Vector3.DOWN * delta
	else:
		gravity_local = gravity_acceleration * -get_floor_normal() * delta
			
	if Input.is_action_just_pressed("jump") && is_on_floor():
		gravity_local = Vector3.UP * jump_force
	
	move_and_slide(input_move + gravity_local, Vector3.UP)

func get_dir() -> Vector3:
	var z: float = (
		Input.get_action_strength("foward") - Input.get_action_strength("backward")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	return transform.basis.xform(Vector3(x,0,z)).normalized()
