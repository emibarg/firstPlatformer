extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
var enemy_death_effect = preload("res://ENEMIES/enemy_death_effect.tscn")
const MAX_HP : int =200
var current_hp : int = MAX_HP
@export var wait_time : int = 3
@export var GRAVITY : int = 1000
@export var SPEED : int = 200
@export var patrol_points : Node
@export var damage_amount : int = 1
enum State{IDLE,WALK}
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else: 
		print("No patrol points")
			
	current_state = State.IDLE
	timer.wait_time = wait_time

func _physics_process(delta : float):
	enemy_gravity(delta)
	enemy_walk(delta)
	enemy_animations()
	
	
	move_and_slide()
	

func enemy_gravity(delta : float):
	velocity.y = GRAVITY * delta

func enemy_idle(delta : float):
	if !can_walk:
		velocity.x = move_toward(velocity.x , 0, SPEED * delta)
		current_state = State.IDLE
	
	
func enemy_walk(delta : float):
	if !can_walk:
		return

	var distance_to_point = abs(position.x - current_point.x)
	if distance_to_point > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.WALK
	else:
		# Stop the character's movement
		current_state = State.IDLE
		velocity.x = 0

		current_point_position += 1
		if current_point_position >= number_of_points:
			current_point_position = 0
		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()

	# Update sprite direction
	animated_sprite_2d.flip_h = direction.x > 0
	

	
func enemy_animations():
	if current_state == State.IDLE and !can_walk:
		animated_sprite_2d.play("IDLE")
	elif current_state == State.WALK and can_walk:
		animated_sprite_2d.play("WALKING")
		

func _on_timer_timeout():
	can_walk = true


func _on_hurtbox_area_entered(area: Area2D):
	var parent_node = area.get_parent()
	if parent_node.has_method("get_damage_amount"):
		current_hp -= parent_node.get_damage_amount()
	if current_hp<=0:
		var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
		enemy_death_effect_instance.global_position=global_position
		get_parent().add_child(enemy_death_effect_instance)
		queue_free()

