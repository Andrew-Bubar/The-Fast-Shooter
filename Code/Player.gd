extends KinematicBody

export var mouse_sensitivity: float = 0.2
export var speed: float = 5
export var max_speed: float = 15
export var jump_force: float = 5
export var gravity_acceleration: float = 12

onready var look = $LookPiviot
onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var gun1 = $LookPiviot/Hand/Gun1
onready var gun2 = $LookPiviot/Hand/Gun2
onready var gun3 = $LookPiviot/Hand/Gun3

var current_gun = 1
var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1 * event.relative.x * mouse_sensitivity))
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if current_gun < 3:
					current_gun += 1
				else:
					current_gun = 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if current_gun > 1:
					current_gun -= 1
				else:
					current_gun = 3

func _physics_process(delta):
	
	gun_select()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	input_move = get_dir() * speed
	if not is_on_floor():
		gravity_local += gravity_acceleration * Vector3.DOWN * delta
	else:
		gravity_local = gravity_acceleration * -get_floor_normal() * delta

	move_and_slide(input_move + gravity_local, Vector3.UP)
	
func gun_select():
	
	if Input.is_action_just_pressed("Weapon1"):
		current_gun = 1
	elif Input.is_action_just_pressed("Weapon2"):
		current_gun = 2
	elif Input.is_action_just_pressed("Weapon3"):
		current_gun = 3
		
	if current_gun == 1:
		gun1.visible = true
		gun1.shoot()
	else:
		 gun1.visible = false
		
	if current_gun == 2:
		gun2.visible = true
		gun2.shoot()
	else:
		 gun2.visible = false
		
	if current_gun == 3:
		gun3.visible = true
		gun3.shoot()
	else:
		 gun3.visible = false
		

func get_dir() -> Vector3:
	var z: float = (
		Input.get_action_strength("foward") - Input.get_action_strength("backward")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	return transform.basis.xform(Vector3(x,0,z)).normalized()
