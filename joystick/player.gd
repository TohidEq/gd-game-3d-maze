extends CharacterBody2D

@export var speed := 5200;

@onready var move_joystick: Control = $"../joystick_mobile/MarginContainer/move_joystick".get_node("base")

func _process(delta: float) -> void:
  var move_direction = move_joystick.get_direction();
  velocity = move_direction*speed*delta;
  
  move_and_slide();
  
