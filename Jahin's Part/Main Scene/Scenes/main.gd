extends Node3D

@export var reeling_speed = 0.05

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		$Path3D.curve.set_point_position(2, Vector3.UP * reeling_speed + $Path3D.curve.get_point_position(2))
	
	if Input.is_action_pressed("move_down"):
		$Path3D.curve.set_point_position(2, Vector3.DOWN * reeling_speed + $Path3D.curve.get_point_position(2))
	
	if Input.is_action_pressed("move_left"):
		$Path3D.curve.set_point_position(2, Vector3.LEFT * reeling_speed + $Path3D.curve.get_point_position(2))
	
	if Input.is_action_pressed("move_right"):
		$Path3D.curve.set_point_position(2, Vector3.RIGHT * reeling_speed + $Path3D.curve.get_point_position(2))
