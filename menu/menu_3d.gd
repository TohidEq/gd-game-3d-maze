extends Node3D

@onready var x: Node3D = $x
@onready var y: Node3D = $y
@onready var z: Node3D = $z

func getXYZ():
  return [x.value, y.value, z.value]
  
