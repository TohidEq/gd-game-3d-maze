extends Node3D

@export var value = 11;
@export var min_val:int = 5;
@export var max_val:int = 99;
@export var steps:int = 2;

@export var titleOnly:bool = false;

@onready var titile: Label3D = $titile
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  titile.text=str(value);
  if(titleOnly):
    mesh_instance_3d.visible=false;
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
  
func increase() ->void:
  if(not titleOnly and value + steps <= max_val):
    value += steps;

func decrease() ->void:
  if(not titleOnly and value - steps >= min_val):
    value -= steps;
