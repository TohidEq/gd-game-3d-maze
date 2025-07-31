extends TextureRect

@export var radius : float = 100.0;
var direction : Vector2 = Vector2.ZERO;
var touch_id :int = -1;

@onready var stick: TextureRect = $stick
@onready var center_marker: Marker2D = $center_marker

@onready var distance_to_marker = (center_marker.position.distance_to(stick.position));


func _ready() -> void:
  _reset_stick()
  pass


func _input(event: InputEvent) -> void:
  if event is InputEventScreenTouch:
    if event.pressed and touch_id==-1 and get_global_rect().has_point(event.position):
      touch_id = event.index
    elif not event.pressed and event.index == touch_id:
      touch_id=-1;
      direction=Vector2.ZERO
      _reset_stick()
  elif event is InputEventScreenDrag and event.index == touch_id:
    var center = global_position + (size /2)
    var relative = event.position - center
    
    if relative.length() > radius:
      relative = relative.normalized() * radius; 
      
    direction = relative.normalized() 
    distance_to_marker = (center_marker.position.distance_to(stick.position));
    stick.position = (self.size/2) - (stick.size/2) + relative
    


func _process(delta: float) -> void:
  pass


func _reset_stick() -> void:
  distance_to_marker = 0.0
  stick.position= (self.size/2) - (stick.size/2)
  
func get_direction() -> Vector2:
  return direction;

func get_distance() -> float:
  return distance_to_marker;
  
  
