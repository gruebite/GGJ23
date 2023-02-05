extends Control

signal again()
signal exit()

func set_score(score: int) -> void:
	$"%Score".text = str(score)
	


func _on_again_pressed() -> void:
	emit_signal("again")


func _on_exit_pressed() -> void:
	emit_signal("exit")
