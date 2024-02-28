extends CharacterBody2D
var bullet = preload("res://PLAYER/bullet.tscn")
var player_death_effect = preload("res://PLAYER/player_death_effect.tscn")
@onready var muzzle : Marker2D = $Muzzle
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_animation_player = $HitAnimationPlayer
@export var GRAVITY : int = 1000
@export var SPEED : int = 300
@export var JUMP : int = -300
@export var JUMPBOOST : int = 100
@export var MAX_H_SPEED : int = 300
@export var MAX_H_JUMP_SPEED : int = 300
@export var SLOWDOWN_SPEED : int = 1000
enum State {IDLE, RUN, JUMP, SHOOT}
var current_state : State
var character_sprite : Sprite2D
var muzzle_position


func _ready():
	current_state = State.IDLE
	muzzle_position = muzzle.position


func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_pos()
	player_shooting(delta)
	move_and_slide()
	player_animations()
	
	
	##print ("State: ", State.keys()[current_state])
	

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY*delta
		
func player_idle(delta : float):
	if is_on_floor():
		current_state = State.IDLE
		
	
func player_run(delta: float):
	if !is_on_floor():
		return
	
	var direction = input_movement()
	
	if direction:
		# Accelerate in the input direction
		velocity.x = direction * SPEED
		
		# Set the current state to RUN if moving
		current_state = State.RUN
		animated_sprite_2d.flip_h = direction < 0  # Flip sprite based on direction
	else:
		# Apply quick deceleration if no input direction
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN_SPEED * delta)
		if abs(velocity.x) < 10:  # Adjust this threshold based on your game's needs
			velocity.x = 0
		current_state = State.IDLE  # Set state to IDLE when not moving

	# Clamp velocity to stay within maximum horizontal speed
	velocity.x = clamp(velocity.x, -MAX_H_SPEED, MAX_H_SPEED)

		
func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP
		current_state = State.JUMP
	if !is_on_floor() and current_state == State.JUMP:
		var direction = input_movement()
		velocity.x += direction * JUMPBOOST *delta
		velocity.x = clamp(velocity.x, -MAX_H_SPEED, MAX_H_SPEED)
func player_shooting(delta : float): 
	var direction = input_movement()
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.SHOOT
	
func player_muzzle_pos():
	var direction = input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x
func player_animations():
	if current_state == State.IDLE:
		animated_sprite_2d.play("IDLE")
	elif current_state == State.RUN and animated_sprite_2d.animation != "RUN_SHOOT" :
		animated_sprite_2d.play("RUN") 
	elif  current_state == State.JUMP:
		animated_sprite_2d.play("JUMP")
	elif  current_state == State.SHOOT:
		animated_sprite_2d.play("RUN_SHOOT")

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()
		
func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction


func _on_hurtbox_body_entered(body:Node2D):
	if body.is_in_group("Enemy"):
		HealthManager.decrease_health(body.damage_amount)
		hit_animation_player.play("HIT")
	
	if HealthManager.current_health <=0:
		player_death()
		
