extends Node3D
class_name Gun

@export var delay_sec_between_shot: float = 0.1
@onready var delay_shot_timer = $DelayShotTimer
@onready var gun_sound_player: AudioStreamPlayer3D = $GunSoundPlayer
@export var BulletScene: PackedScene
var ready_to_shoot: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	delay_shot_timer.wait_time = delay_sec_between_shot
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	if ready_to_shoot:
		var bullet = BulletScene.instantiate()
		bullet.global_transform = global_transform
		get_tree().root.add_child(bullet)
#		add_child(bullet)
		delay_shot_timer.start()
		
		gun_sound_player.play()
		ready_to_shoot = false
	pass


func _on_delay_shot_timer_timeout():
	ready_to_shoot = true
	pass # Replace with function body.
