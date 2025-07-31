extends Node

class_name Maze3D

var x_size = 5
var y_size = 3
var z_size = 5

var x_Start = 1
var y_Start = 1
var z_Start = 1

var grid: Array = []

func _init(_x: int, _y: int, _z: int):
  x_size = _x
  y_size = _y
  z_size = _z
  
  initGrid()

  x_Start = 1
  y_Start = 1
  z_Start = 1

func initGrid() -> void:
  grid = []
  for zi in range(z_size):
    var layer = []
    for yi in range(y_size):
      var newLayer=[]
      for xi in range(x_size):
        newLayer.append(true);
      layer.append(newLayer)
    grid.append(layer)

func getGrid() -> Array:
  grid[0][1][0]=false;
  grid[1][1][0]=false;
  grid[1][1][1]=false;
  grid[1][2][1]=false;
  
  return grid

func isBounds(_x: int, _y: int, _z: int) -> bool:
  return (
    _x >= 0 and _x < x_size and
    _y >= 0 and _y < y_size and
    _z >= 0 and _z < z_size
  )

func get_neighbors(_x: int, _y: int, _z: int, canBeCraved: bool = false, onlyCraved: bool = false) -> Array:
  var neighbors: Array = []

  var directions = [
    [0, 0, -2],  # back
    [0, 0, 2],   # forward
    [0, -2, 0],  # up
    [2, 0, 0],   # right
    [0, 2, 0],   # down
    [-2, 0, 0]   # left
  ]

  for dir in directions:
    var nx = _x + dir[0]
    var ny = _y + dir[1]
    var nz = _z + dir[2]

    var condition := false
    if onlyCraved:
      if isBounds(nx, ny, nz) and not grid[nz][ny][nx]:
        condition = true
    elif canBeCraved:
      if isBounds(nx, ny, nz) and grid[nz][ny][nx]:
        condition = true
    elif isBounds(nx, ny, nz) and grid[nz][ny][nx]:
      condition = true

    if condition:
      neighbors.append([nx, ny, nz])

  return neighbors

func carve_path(x1: int, y1: int, z1: int, x2: int, y2: int, z2: int) -> void:
  var mx = (x1 + x2) >> 1
  var my = (y1 + y2) >> 1
  var mz = (z1 + z2) >> 1

  grid[z1][y1][x1] = false
  grid[mz][my][mx] = false
  grid[z2][y2][x2] = false

func generate_dfs(_x: int = x_Start, _y: int = y_Start, _z: int = z_Start) -> Array:
  grid[_z][_y][_x] = false

  var stack: Array = [[_x, _y, _z]]

  while stack.size() > 0:
    var current = stack[stack.size() - 1]
    var x = current[0]
    var y = current[1]
    var z = current[2]

    var neighbors = get_neighbors(x, y, z)

    if neighbors.size() == 0:
      stack.pop_back()
    else:
      var random_index = randi() % neighbors.size()
      var neighbor = neighbors[random_index]
      var nx = neighbor[0]
      var ny = neighbor[1]
      var nz = neighbor[2]

      carve_path(x, y, z, nx, ny, nz)

      stack.append([nx, ny, nz])

  return grid

# این دو تابع کمکی باید بیرون از generate_prime تعریف بشن
func walls_remove_item_by_index(walled_neighbors: Array, index: int) -> void:
  var last_index = walled_neighbors.size() - 1
  var temp = walled_neighbors[index]
  walled_neighbors[index] = walled_neighbors[last_index]
  walled_neighbors[last_index] = temp
  walled_neighbors.pop_back()

func walls_add_if_not_exists(walled_neighbors: Array, new_item: Array) -> void:
  for item in walled_neighbors:
    if item == new_item:
      return
  walled_neighbors.append(new_item)

func generate_prime(_x: int = x_Start, _y: int = y_Start, _z: int = z_Start) -> void:
  grid[_z][_y][_x] = false

  var walled_neighbors: Array = []

  var neighbors = get_neighbors(_x, _y, _z)
  for wall in neighbors:
    walls_add_if_not_exists(walled_neighbors, wall)

  while walled_neighbors.size() != 0:
    var random_neighbors_index = randi() % walled_neighbors.size()
    var wx = walled_neighbors[random_neighbors_index][0]
    var wy = walled_neighbors[random_neighbors_index][1]
    var wz = walled_neighbors[random_neighbors_index][2]

    var craved_neighbors = get_neighbors(wx, wy, wz, true, true)

    if craved_neighbors.size() > 0:
      grid[wz][wy][wx] = false

      var random_craved_neighbors_index = randi() % craved_neighbors.size()
      var cnx = craved_neighbors[random_craved_neighbors_index][0]
      var cny = craved_neighbors[random_craved_neighbors_index][1]
      var cnz = craved_neighbors[random_craved_neighbors_index][2]

      carve_path(wx, wy, wz, cnx, cny, cnz)

      var new_walls = get_neighbors(wx, wy, wz)
      for wall in new_walls:
        walls_add_if_not_exists(walled_neighbors, wall)

    walls_remove_item_by_index(walled_neighbors, random_neighbors_index)
