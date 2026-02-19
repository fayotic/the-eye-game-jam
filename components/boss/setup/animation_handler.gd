extends Node3D

@export var anim_player: AnimationPlayer

@export var segments: Dictionary = {
	"idle": {"start":0.0, "end":2.7, "loop":true},
	"walk": {"start":2.9, "end":4.8, "loop":true},
	"attack": {"start":4.9, "end":7.0, "loop":false}
}

var current_segment: String = ""

func play_anim(anim_name: String) -> void:
	if not segments.has(anim_name):
		return

	if current_segment == anim_name:
		return

	current_segment = anim_name
	var s = segments[anim_name]
	anim_player.play("ArmatureAction")
	anim_player.seek(s.start, true)

func _process(_delta: float) -> void:
	if current_segment == "":
		return

	var s = segments[current_segment]
	if anim_player.current_animation_position >= s.end:
		if s.loop:
			anim_player.seek(s.start, true)
		else:
			current_segment = ""
