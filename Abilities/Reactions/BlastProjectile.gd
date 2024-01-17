extends CharacterBody2D

var speed = 0
var dmg = 0
var center

func init(init_speed, init_dmg, init_center):
	speed = init_speed
	dmg = init_dmg
	center = init_center

func _physics_process(delta):
	var collision = move_and_collide((self.global_position - center.global_position).normalized() * delta * speed)
		# check collisions
	if collision and collision.get_collider().get_name() != "Player":
		if collision.get_collider().is_in_group("monsters"):
			collision.get_collider()._hit(dmg, $Texture.color)
		queue_free()
