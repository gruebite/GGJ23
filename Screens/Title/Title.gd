extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TitleMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$TitleMusic.stop()
	$GameStartSound.play()
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Screens/Game/Game.tscn")
