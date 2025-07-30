extends CharacterBody3D

const SPEED = 3
const JUMP_VELOCITY = 4.5

@onready var move_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_joystick").get_node("base")

@onready var view_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/view_joystick").get_node("base")

@onready var move_view_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_view_joystick").get_node("base")

@export var rotation_speed := 200.0

func _process(delta: float) -> void:
  print(move_joystick.get_direction()[0], view_joystick.get_direction(), move_view_joystick.get_direction())

func _physics_process(delta: float) -> void:

  var input_dir := Input.get_vector("LEFT_A_KEY", "RIGHT_D_KEY", "DOWN_S_KEY", "TOP_W_KEY")
  var direction := Vector3.ZERO

  # move: frwrd bckwrd left right
  direction += -transform.basis.z * input_dir.y
  direction += transform.basis.x * input_dir.x

  # move: top down
  if Input.is_action_pressed("move_up"):
    direction += transform.basis.y
  if Input.is_action_pressed("move_down"):
    direction -= transform.basis.y

  direction = direction.normalized()

  if direction != Vector3.ZERO:
      velocity = direction * SPEED
  else:
      velocity = velocity.move_toward(Vector3.ZERO, SPEED)

  
  print("player direction:",direction)
  
  # rotates
  if Input.is_action_pressed("rotate_left"):
    rotate_object_local(Vector3.UP, deg_to_rad(rotation_speed * delta))
  
  if Input.is_action_pressed("rotate_right"):
    rotate_object_local(Vector3.UP, deg_to_rad(-rotation_speed * delta))

  if Input.is_action_pressed("rotate_top"):
    rotate_object_local(Vector3.RIGHT, deg_to_rad(rotation_speed * delta))

  if Input.is_action_pressed("rotate_down"):
    rotate_object_local(Vector3.RIGHT, deg_to_rad(-rotation_speed * delta))
    
  
  if Input.is_action_pressed("rotate_q"):
    rotate_object_local(Vector3.FORWARD, deg_to_rad(-rotation_speed * delta))
    
  if Input.is_action_pressed("rotate_e"):
    rotate_object_local(Vector3.FORWARD, deg_to_rad(rotation_speed * delta))
    
  move_and_slide()
