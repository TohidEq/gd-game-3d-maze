extends CharacterBody3D

const SPEED = 150
@export var rotation_speed := 150.0

@onready var move_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_joystick").get_node("base")
@onready var move_top_down_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/move_top_down_joystick").get_node("base")



@onready var view_left_right_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/view_left_right_joystick").get_node("base")
@onready var view_top_down_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/view_top_down_joystick").get_node("base")

# q e rotates
@onready var view_rotate_joystick: Control = $ui.get_node("joystick_mobile/MarginContainer/view_rotate_joystick").get_node("base")

var is_touching_settingBox:bool=false;


var touched_settingBox: Node = null

var time_accumulator = 0.0
func _process(delta):
    time_accumulator += delta
    if time_accumulator >= 0.2:
        time_accumulator = 0.0
        print(touched_settingBox)
        
        var q_and_e_touch = view_rotate_joystick.get_direction()[0];
        if(is_touching_settingBox and (touched_settingBox !=null)):
          if(q_and_e_touch>0):
            touched_settingBox.increase();
          elif(q_and_e_touch<0):
            touched_settingBox.decrease();
            
        
        

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

  
  #print("player direction:",direction)
  
  # rotates
  var left_and_right_view_touch = view_left_right_joystick.get_direction()[0];
  rotate_object_local(Vector3.UP, deg_to_rad(-left_and_right_view_touch*rotation_speed * delta * (int(view_left_right_joystick.get_distance())/100.0)))
  
  var down_and_top_touch = view_top_down_joystick.get_direction()[1];
  rotate_object_local(Vector3.RIGHT, deg_to_rad(
    -down_and_top_touch * rotation_speed * delta * 
    (int(view_top_down_joystick.get_distance())/100.0)
    ))
    
  # Q and E rotates
  var q_and_e_touch = view_rotate_joystick.get_direction()[0];
  if(not is_touching_settingBox):
    rotate_object_local(Vector3.FORWARD, deg_to_rad(q_and_e_touch * 
      rotation_speed * 
      delta * 
      (int(view_rotate_joystick.get_distance())/100.0)
      ))
      
    
    
    
  move_and_slide()

func entered_settingBox(thatBox):
  is_touching_settingBox=true;
  touched_settingBox=thatBox;
func exited_settingBox():
  is_touching_settingBox=false;
  touched_settingBox=null
  
  
func _ready() -> void:
  pass
  
        
    
