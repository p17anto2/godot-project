extends Area2D

#Objects
onready var player = self.get_owner()
onready var hear_col = $HearCollision

func _ready():
	hear_col.shape.set_radius(0)

func _physics_process(delta):

	if Input.is_action_pressed("ui_hear"):
		hear_col.shape.set_radius(player.radius)
	else:
		hear_col.shape.set_radius(0)


func _on_HearArea_body_entered(body):
	if body != player:
		body.show()
