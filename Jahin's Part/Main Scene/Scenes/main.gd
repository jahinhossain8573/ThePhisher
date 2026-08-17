extends Node3D

#Movement Speed
@export var reeling_speed = 0.05

#AI Scene
@export var ai_scene : PackedScene = null
@export var ai_spawn_location : PathFollow3D = null

func _process(delta: float) -> void:
	$Path3D/PathFollow3D/Clickbait/Minigame.global_rotation.y = 0

func _physics_process(delta: float) -> void:
	#Movement
	if Input.is_action_pressed("move_up"):
		$Path3D.curve.set_point_position(2, Vector3.FORWARD * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
	
	if Input.is_action_pressed("move_down"):
		$Path3D.curve.set_point_position(2, Vector3.BACK * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
		
	if Input.is_action_pressed("move_left"):
		$Path3D.curve.set_point_position(2, Vector3.LEFT * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
		
	if Input.is_action_pressed("move_right"):
		$Path3D.curve.set_point_position(2, Vector3.RIGHT * reeling_speed + $Path3D.curve.get_point_position(2))
		$Path3D/PathFollow3D.progress_ratio = 1
	
#AI Spawning
func _on_timer_timeout() -> void:
	#AI Scene Instantiation
	var ai : CharacterBody3D = ai_scene.instantiate()
	
	#Randomizes the Spawn Position
	ai_spawn_location.progress_ratio = randf()
	
	#Selects the node to which the AI moves
	var assembly_points : Array[Node] = $"AI Manager".get_children()
	ai.target_node = assembly_points[randi_range(0, $"AI Manager".get_child_count()-1)]
	
	#Adds in the AI Scene as a node in the scene tree
	add_child(ai)
	
	#Sets the position of the AI
	ai.global_position = ai_spawn_location.global_position
	ai.global_position.y = 0.215
	ai.initial_position = ai.global_position

func _on_qte_quick_time_success() -> void:
	$Path3D/PathFollow3D/Clickbait.successful_qt()

func _on_qte_quick_time_failure() -> void:
	$Path3D/PathFollow3D/Clickbait.unsuccessful_qt()
