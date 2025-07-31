extends TextureRect

signal touch_action(action_name: String)
@onready var btn: Control = $".."

var touch_id: int = -1


func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if touch_id == -1 and get_global_rect().has_point(event.position):
                touch_id = event.index
                touch_action.emit(btn.val)
                #print(btn.val)
        elif not event.pressed and event.index == touch_id:
            touch_id = -1
