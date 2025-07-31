extends Node3D

@export var beforeValue:String = ""; 
@export var value:int = 11;
@export var min_val:int = 5;
@export var max_val:int = 99;
@export var steps:int = 2;

@export var titleOnly:bool = false;

@onready var titile: Label3D = $titile
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if(titleOnly):
    titile.text=str(beforeValue);
    mesh_instance_3d.visible=false;
  else:
    titile.text=str(beforeValue)+str(value);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  
  pass
  
  
func increase() ->void:
  if(not titleOnly and value + steps <= max_val):
    value += steps;
    titile.text=str(beforeValue)+str(value);
    

func decrease() ->void:
  if(not titleOnly and value - steps >= min_val):
    value -= steps;
    titile.text=str(beforeValue)+str(value);
    






func _on_settings_block_area_body_entered(body: Node3D) -> void:
  print("body entered:",body.name)
  if(body.name=="player"):
    body.entered_settingBox(self);
    



func _on_settings_block_area_body_exited(body: Node3D) -> void:
  print("body exited:",body.name)
  if(body.name=="player"):
    body.exited_settingBox();
