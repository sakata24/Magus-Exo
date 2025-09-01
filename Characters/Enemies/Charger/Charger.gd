class_name Charger extends Monster

var lock_target
var dashing = false
var canHit = true
var speed_multiplier = 4.0
# how long the dash is
var dash_time = 0.4
# already hit player in dash
var did_hit = false
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var dmg_area: Area2D = $DamageArea
@onready var indicator: Node2D = $DamageArea/Indicator

func _ready():
	attack_range = 90
	super()

func _on_damage_area_body_entered(body: CharacterBody2D):
	if body.is_in_group("players") and not did_hit:
		var damage_object = DamageObject.new(my_dmg)
		player.hit(damage_object)
		did_hit = true

func _physics_process(delta: float) -> void:
	super(delta)
