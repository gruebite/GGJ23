class_name CardContainer extends MarginContainer

signal selected()

var mouse_over := false
var mouse_down := false


func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if mouse_over:
			if event.pressed:
				mouse_down = true
			else:
				if mouse_down:
					emit_signal("selected")
		else:
			mouse_down = false


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
