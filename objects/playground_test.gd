extends Node3D


@onready var menu_3d: Node3D = $Menu3d
@onready var start_maze: Node3D = $StartMaze




var waitForStart = true;
func _process(delta: float) -> void:
  if waitForStart:
    if start_maze.value!=0:
      waitForStart=false;
      
      var xyz = menu_3d.getXYZ();
      var x=xyz[0];
      var y=xyz[1];
      var z=xyz[2];
      
      var testClass=Maze3D.new(x,y,z);
      
      if start_maze.value == 1:
        testClass.generate_dfs()
      if start_maze.value == -1:
        testClass.generate_prime()
        
      var grid=(testClass.getGrid())
      
      grid[1][1][0]=false;
      
      grid[z-2][y-2][x-2]=false;
      grid[z-2][y-2][x-1]=false;
      grid[z-2][y-1][x-2]=false;
      grid[z-2][y-1][x-1]=false;
      grid[z-1][y-2][x-2]=false;
      grid[z-1][y-2][x-1]=false;
      grid[z-1][y-1][x-2]=false;
      grid[z-1][y-1][x-1]=false;
      
      
      
      
      
      for zi in range(z): # z
        for yi in range(y): # y
          for xi in range(x): # x
            if(grid[zi][yi][xi]):
              clone_object_at_position_3d(Vector3(xi+1,yi,zi-2))
    
    
    




const BOX = preload("res://objects/box.tscn")
func clone_object_at_position_3d(position: Vector3):
    var new_instance = BOX.instantiate()
    new_instance.global_transform.origin = position
    add_child(new_instance)
