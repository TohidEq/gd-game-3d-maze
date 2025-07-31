extends CharacterBody3D

const SPEED = 150
@export var rotation_speed := 150.0

@onready var move_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_joystick").get_node("base")
@onready var move_top_down_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_top_down_joystick").get_node("base")





var is_touching_settingBox:bool=false;


var touched_settingBox: Node = null
        

func _physics_process(delta: float) -> void:

  var direction := Vector3.ZERO

  # move: frwrd bckwrd left right

  var bckwrd_and_frwrd_touch = move_joystick.get_direction()[1];  
  direction += transform.basis.z * bckwrd_and_frwrd_touch
  
  var left_and_right_move_touch =  move_joystick.get_direction()[0];  
  direction += transform.basis.x * left_and_right_move_touch 



  # move: top down
  var ctrl_and_space_touch = move_top_down_joystick.get_direction()[1];
  direction -= ctrl_and_space_touch*transform.basis.y
  
  direction = direction.normalized()

  if direction != Vector3.ZERO:
      velocity = direction * SPEED*delta * maxf(
        int(move_joystick.get_distance())/100.0,
        int(move_top_down_joystick.get_distance())/100.0 )
  else:
      velocity = velocity.move_toward(
          Vector3.ZERO, 
          SPEED*delta
        )

    
  move_and_slide()

func entered_settingBox(thatBox):
  is_touching_settingBox=true;
  touched_settingBox=thatBox;
func exited_settingBox():
  is_touching_settingBox=false;
  touched_settingBox=null
  

func _ready():
    var buttons = $ui/joystick_mobile/MarginContainer/btns_view.get_children()
    for btn in buttons:
        var base = btn.get_node("base")
        base.touch_action.connect(touch_view_handler);
  

  
var is_rotating := false

func _rotate_smoothly_local(axis: Vector3, angle_deg: float, duration := 0.3) -> void:
  if is_rotating:
    return
  is_rotating = true
  
  #  --------------------
  if axis.length() == 0:
      print("Warning: axis vector is zero, skipping rotation.")
      is_rotating = false
      return
  #  --------------------
      
      
  var local_axis = global_transform.basis * axis.normalized()
  var angle_rad = deg_to_rad(angle_deg)

  var target_basis = transform.basis.rotated(local_axis, angle_rad)

  var tween = create_tween()
  tween.tween_property(self, "transform:basis", target_basis, duration)\
    .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

  tween.connect("finished", Callable(self, "_on_rotation_done"))

func _on_rotation_done():
  is_rotating = false

  
func turn_left() -> void:
  _rotate_smoothly_local(Vector3.UP, 90)

func turn_right() -> void:
  _rotate_smoothly_local(Vector3.UP, -90)

func turn_up() -> void:
  _rotate_smoothly_local(Vector3.RIGHT, 90)

func turn_down() -> void:
  _rotate_smoothly_local(Vector3.RIGHT, -90)

func roll_left() -> void:
  if(is_touching_settingBox):
    touched_settingBox.decrease();
  else:
    _rotate_smoothly_local(Vector3.FORWARD, -90)
    

func roll_right() -> void:
  if(is_touching_settingBox):
    touched_settingBox.increase();
  else:
    _rotate_smoothly_local(Vector3.FORWARD, 90)
  
func touch_view_handler(action_name):
  match action_name:
    "r_left":
      turn_left()
    "r_right":
      turn_right()
    "r_top":
      turn_up()
    "r_down":
      turn_down()
    "r_left_z":
      roll_left()
    "r_right_z":
      roll_right()
    _:
      print("Unknown action:", action_name)
