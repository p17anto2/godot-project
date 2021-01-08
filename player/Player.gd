extends KinematicBody2D

#Objects
onready var animPlayer = $AnimationPlayer #Animation player node
onready var player = $CollisionShape2D #Player Node
onready var playerSprite = $Sprite #Player Sprite

#Player Movement
var can_move = true #If the player is able to move
var velocity = Vector2.ZERO #Current velocity
const SPEED = 200 #Movement Speed 
var current_ground = 0 #The type of ground player is on currently

#Hearing
const START_RANGE = 10 #Staring hearing range
const HEAR_RANGE = 200 #Maximum hearing range
const HEAR_STEP = 0.04 #Interval between hearing steps
const STEP_DELAY = 0.0001 #Maximum hearing step delay
var step = 0 #Number of steps elapsed
var radius = 0 #Current Radius (Global so other nodes can access)
var circle = [] #Whole Circle Array
var time_to_next_step = null #A counter to the next step

#Code Ugliness: Part of circle arrays for the Besenham Algorithm
var v1 = []
var v2 = []
var v3 = []
var v4 = []
var v5 = []
var v6 = []
var v7 = []
var v8 = []

func _ready(): #Runs once at the start
	time_to_next_step = STEP_DELAY #Initialise time to next step variable

func _physics_process(delta): #Runs every physics frame (delta is constant)
	hear(delta) #Hearing function
	movement() #Movement function
	
func _draw(): #Built-in function. Runs every time update() is called
	#Draw a line from every point of the circle to its next
	for i in range(0, circle.size()-1):
		draw_line(circle[i], circle[i+1], Color(1,1,1,1), 2)

func movement():
	#Movement
	if can_move == true:
		#Calculate Input Axis
		var input_axis = Vector2.ZERO
		input_axis.y = Input.get_action_strength("ui_backward") - Input.get_action_strength("ui_forward")
		input_axis.x = Input.get_action_strength("ui_sideright") - Input.get_action_strength("ui_sideleft")
		
		#Calculate footstep intensity from current ground
		var footstep_intensity = lerp(0, 1, current_ground)
		playerSprite.set_modulate(Color(1, 1, 1, footstep_intensity))
		
		#Animate 8 possible directions and idle
		match input_axis:
			Vector2(0, -1):
				animPlayer.play("Player_Fwd")
			Vector2(1, -1):
				animPlayer.play("Player_FwdR")
			Vector2(-1, -1):
				animPlayer.play("Player_FwdL")
			Vector2(1, 0):
				animPlayer.play("Player_R")
			Vector2(-1, 0):
				animPlayer.play("Player_L")
			Vector2(1, 1):
				animPlayer.play("Player_BwdR")
			Vector2(-1, 1):
				animPlayer.play("Player_BwdL")
			Vector2(0, 1):
				animPlayer.play("Player_Bwd")
			_:
				animPlayer.play("Player_Idle")
		
		#Normalise input axis so that diagonal movement is smooth
		input_axis = input_axis.normalized()
		velocity = input_axis * SPEED #Calculate velocity
		move_and_slide(velocity) #Move and respect collisions

func hear(delta):
	if Input.is_action_pressed("ui_hear"):
		can_move = false #Obstruct movement
		animPlayer.play("Player_Idle") #Play idle animation
		var weight = HEAR_STEP * step #Linear Interpolation Weight
		#If weight >= 1 then we have exceeded our maximum hearing range
		if weight <= 1:
			radius = lerp(START_RANGE, HEAR_RANGE, weight) #Current working radius
			#Calculate Bresenham Circle
			var d = 3 - (2 * radius)
			var x = 0
			var y = radius
			calc_vectors(player.position, x, y)
			while y >= x:
				x += 1
				if d > 0:
					y -= 1
					d = d + 4 * (x-y) + 10
				else: d = d + 4 * x + 6
				calc_vectors(player.position, x , y)
			
			#Create full circle by parts
			for point in v1: circle.append(point)
			v2.invert()
			for point in v2: circle.append(point)
			for point in v3: circle.append(point)
			v4.invert()
			for point in v4: circle.append(point)
			for point in v5: circle.append(point)
			v6.invert()
			for point in v6: circle.append(point)
			for point in v7: circle.append(point)
			v8.invert()
			for point in v8: circle.append(point)
			
			if time_to_next_step >= 0:
				time_to_next_step -= delta
			else:
				#Repeat
				v1.clear()
				v2.clear()
				v3.clear()
				v4.clear()
				v5.clear()
				v6.clear()
				v7.clear()
				v8.clear()
				circle.clear()
				step += 1
				time_to_next_step = STEP_DELAY
			update()
	elif Input.is_action_just_released("ui_hear"):
		can_move = true
		step = 0
		radius = 0
		v1.clear()
		v2.clear()
		v3.clear()
		v4.clear()
		v5.clear()
		v6.clear()
		v7.clear()
		v8.clear()
		circle.clear()
		update()

func calc_vectors(pPos, x, y):
	v1.append(Vector2(pPos.x+x,pPos.y-y))
	v2.append(Vector2(pPos.x+y,pPos.y-x)) 
	v3.append(Vector2(pPos.x+y,pPos.y+x))
	v5.append(Vector2(pPos.x-x,pPos.y+y))
	v4.append(Vector2(pPos.x+x,pPos.y+y))  
	v6.append(Vector2(pPos.x-y,pPos.y+x))
	v7.append(Vector2(pPos.x-y,pPos.y-x)) 
	v8.append(Vector2(pPos.x-x,pPos.y-y))

