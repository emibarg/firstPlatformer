extends AnimatedSprite2D
var bullet_impact_effect = preload("res://PLAYER/bullet_impact_effect.tscn")
const BULLET_DMG : int = 100
@export var SPEED : int = 1000
var direction : int

func  _physics_process(delta):
	move_local_x(direction * SPEED * delta )

func _on_timer_timeout():
	queue_free()


func _on_hitbox_area_entered(area):
	print("Hit something")
	bullet_impact()

func get_damage_amount() -> int :
	return BULLET_DMG

func _on_hitbox_body_entered(body):
	print("bullet body entered")
	bullet_impact()
func bullet_impact():
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()
