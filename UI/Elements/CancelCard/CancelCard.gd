extends CardContainer

signal selected()


func _on_button_pressed() -> void:
	emit_signal("selected")
