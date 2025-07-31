extends Node3D
@onready var menu_3d: Node3D = $Menu3d

@onready var start_maze: Node3D = $StartMaze
var waitForStart = true;
func _process(delta: float) -> void:
  if waitForStart:
    if start_maze.value==1:
      waitForStart=false;
      
      var xyz = menu_3d.getXYZ();
      var x=xyz[0];
      var y=xyz[1];
      var z=xyz[2];
      
      var testClass=Maze3D.new(x,y,z);
      #testClass.generate_dfs()
      testClass.generate_prime()
      var grid=(testClass.getGrid())
      
      for zi in range(z): # z
        for yi in range(y): # y
          for xi in range(x): # x
            if(grid[zi][yi][xi]):
              clone_object_at_position_3d(Vector3(xi,yi,zi))
    

# Called when the node enters the scene tree for the first time.
func _ready() -> void:   
  pass # Replace with function body.




const BOX = preload("res://objects/box.tscn")
func clone_object_at_position_3d(position: Vector3):
    var new_instance = BOX.instantiate()
    new_instance.global_transform.origin = position  # برای Node3D ها
    add_child(new_instance)
