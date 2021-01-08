extends "res://env/BackGround.gd"
#Extension of background script

#Enter and exit signals
func _on_PLoudGround_body_entered(body):
	if body.has_node("HearArea"):
		body.current_ground = intensity

func _on_PLoudGround_body_exited(body):
	if body.has_node("HearArea"):
		body.current_ground = 1
