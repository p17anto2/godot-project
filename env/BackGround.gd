extends Area2D

#Enumerator of the ground types
enum ground_type {
				SILENT = 0,
				BARELY_AUDIBLE = 1,
				AUDIBLE = 2,
				PRETTY_AUDIBLE = 3,
				LOUD = 4
				}
export(ground_type) var type
var intensity = 1

func _ready():
	#Switch-like statement to calculate intensity
	match type:
		0:
			intensity = 0
		1:
			intensity = 0.25
		2:
			intensity = 0.5
		3:
			intensity = 0.75
		4:
			intensity = 1

func _on_BackGround_body_entered(body):
	#If the players enters the area its current ground is treated accordingly
	if body.has_node("HearArea"):
		body.current_ground = intensity
