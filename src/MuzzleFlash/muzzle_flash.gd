extends Node3D
class_name MuzzleFlash
@onready var timer: Timer = $Timer

@export var duration = 0.03 #sec

var sprites: Array[Sprite3D] = []
func _ready():
	timer.wait_time = duration
	sprites.assign(get_node("Sprites").get_children())
	_hide_sprites()
func flash():
	timer.start()
	for sprite in sprites:
		sprite.show()

func _hide_sprites():
	for sprite in sprites:
		sprite.hide()

func _on_timer_timeout():
	_hide_sprites()
