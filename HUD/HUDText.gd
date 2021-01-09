extends Label

var text_to_display = "" #The text to display
var counter = 0 #Current time to next character
const TIME_TO_NEXT_CHARACTER = 0.06 #Time between characters
#
func _ready():
	set_visible_characters(0)
	counter = TIME_TO_NEXT_CHARACTER
	text_to_display = tr("str_buttons")
	set_text(text_to_display)
#
func _physics_process(delta):
	#Animate Text
	if get_visible_characters() != text_to_display.length():
		if counter < 0:
			set_visible_characters(get_visible_characters() + 1)
			counter = TIME_TO_NEXT_CHARACTER
		else:
			counter -= delta
