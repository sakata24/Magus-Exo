class_name Charger extends Monster

var lock_target
var dashing = false
var canHit = true
var speed_multiplier = 5.0
# how long the dash is
var dash_time = 0.4
# already hit player in dash
var did_hit = false

func _ready():
	attack_range = 70
	super()

func _on_damage_area_body_entered(body):
	if body.name == "Player":
		var damage_object = DamageObject.new(my_dmg)
		player.hit(damage_object)
		did_hit = true

func _physics_process(delta: float) -> void:
	super(delta)
