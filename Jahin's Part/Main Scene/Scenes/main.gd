extends Node3D

#Movement Speed
@export var reeling_speed = 0.05

#AI Scene
@export var ai_scene : PackedScene = null
@export var ai_spawn_location : PathFollow3D = null

func _physics_process(delta: float) -> void:
	#Movement
	if Input.is_action_pressed("move_up"):
		$Path3D.curve.set_point_position(2, Vector3.UP * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
	
	if Input.is_action_pressed("move_down"):
		$Path3D.curve.set_point_position(2, Vector3.DOWN * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
		
	if Input.is_action_pressed("move_left"):
		$Path3D.curve.set_point_position(2, Vector3.LEFT * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
		
	if Input.is_action_pressed("move_right"):
		$Path3D.curve.set_point_position(2, Vector3.RIGHT * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
	
#AI Spawning
func _on_timer_timeout() -> void:
	var ai : CharacterBody3D = ai_scene.instantiate()
	ai_spawn_location.progress_ratio = randf()
	ai.global_position = ai_spawn_location.position
	add_child(ai)
