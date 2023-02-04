extends CardContainer

signal selected()


func _on_button_pressed() -> void:
	print("hi")
	emit_signal("selected")
