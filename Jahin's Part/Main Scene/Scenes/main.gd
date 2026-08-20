extends Node3D

#Movement Speed
@export var reeling_speed = 0.05

#AI Scene
@export var ai_scene : PackedScene = null
@export var ai_spawn_location : PathFollow3D = null

@onready var clickbait : Clickbait = $Path3D/PathFollow3D/Clickbait

var can_move : bool = false

var score : int = 0

var input_accept : bool = true

@onready var gameplay_ui: GameplayUI = $"Camera3D/UI Manager/Sprite3D/SubViewport/GameplayUI"

@onready var session_timeout_timer: Timer = $SessionTimer/SessionTimeoutTimer
@onready var gameplay_ui_1: HighScoreDisplay = $"Camera3D/UI Manager/Sprite3D1/SubViewport/GameplayUI1"


func _ready() -> void:
	GameManager.load_game()
	print(score)
	$Path3D/PathFollow3D/Clickbait.initial_position = $Path3D.curve.get_point_position(2)
	

func _process(delta: float) -> void:
	$Path3D/PathFollow3D/Clickbait/Minigame.global_rotation.y = 0
	$Path3D/PathFollow3D/Clickbait/Minigame.global_position.z = clickbait.global_position.z + 0.4
	gameplay_ui.label.text = "Score: " + str(score)
	gameplay_ui_1.label.text = "High Score: " + str(GameManager.high_score)
	
	$TimeLeft.text = "Time Left: %.2f" % $SessionTimer.time_left

func _physics_process(delta: float) -> void:
	#Movement
	if input_accept:
		if can_move:
			if $Path3D/PathFollow3D/Clickbait/Minigame/SubViewport/QTE.enabled == false:
				if Input.is_action_pressed("move_up"):
					$Path3D.curve.set_point_position(2, Vector3.FORWARD * reeling_speed + $Path3D.curve.get_point_position(2))
					var position = $Path3D.curve.get_point_position(2)
					position.z = clamp(position.z, -1.118, 5.926)
					$Path3D.curve.set_point_position(2, position)
					$Path3D/PathFollow3D.progress_ratio = 1
				
				if Input.is_action_pressed("move_down"):
					$Path3D.curve.set_point_position(2, Vector3.BACK * reeling_speed + $Path3D.curve.get_point_position(2))
					var position = $Path3D.curve.get_point_position(2)
					position.z = clamp(position.z, -1.118, 5.926)
					$Path3D.curve.set_point_position(2, position)
					$Path3D/PathFollow3D.progress_ratio = 1
					
				if Input.is_action_pressed("move_left"):
					$Path3D.curve.set_point_position(2, Vector3.LEFT * reeling_speed + $Path3D.curve.get_point_position(2))
					var position = $Path3D.curve.get_point_position(2)
					position.x = clamp(position.x, -8.844, 8.844)
					$Path3D.curve.set_point_position(2, position)
					$Path3D/PathFollow3D.progress_ratio = 1
					
				if Input.is_action_pressed("move_right"):
					$Path3D.curve.set_point_position(2, Vector3.RIGHT * reeling_speed + $Path3D.curve.get_point_position(2))
					var position = $Path3D.curve.get_point_position(2)
					position.x = clamp(position.x, -8.844, 8.844)
					$Path3D.curve.set_point_position(2, position)
					$Path3D/PathFollow3D.progress_ratio = 1
		else:
			if Input.is_action_just_pressed("move_up"):
				if clickbait.type >= 5:
					clickbait.type = 0
				else:
					clickbait.type += 1
				clickbait.type_change()
				#print(clickbait.type)
				
			if Input.is_action_just_pressed("move_down"):
				if clickbait.type <= 0:
					clickbait.type = 5
				else:
					
					clickbait.type -= 1
				clickbait.type_change()
				#print(clickbait.type)
			
			if Input.is_action_just_pressed("select"):
				can_move = true
				$AnimationPlayer.play("Clickbait Select Start")

#AI Spawning
func _on_timer_timeout() -> void:
	#AI Scene Instantiation
	var ai : AI = ai_scene.instantiate()
	
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
	
	#print(ai.ai_type)

func _on_qte_quick_time_success() -> void:
	$Path3D/PathFollow3D/Clickbait.successful_qt()
	if $Path3D/PathFollow3D/Clickbait.ai_array.size() == 0:
		$Path3D.curve.set_point_position(2, $Path3D/PathFollow3D/Clickbait.initial_position)
		can_move = false
		$AnimationPlayer.play("Clickbait Select Start")
	score += 15
	if score > GameManager.high_score:
		GameManager.high_score = score
		GameManager.save_game()

func _on_qte_quick_time_failure() -> void:
	$Path3D/PathFollow3D/Clickbait.unsuccessful_qt()
	if $Path3D/PathFollow3D/Clickbait.ai_array.size() == 0:
		$Path3D.curve.set_point_position(2, $Path3D/PathFollow3D/Clickbait.initial_position)
		can_move = false
		$AnimationPlayer.play_backwards("Clickbait Select Start")
	if score <= 0:
		$Path3D.curve.set_point_position(2, $Path3D/PathFollow3D/Clickbait.initial_position)
		can_move = false
		$AnimationPlayer.play_backwards("Try Again")
		$AnimationPlayer.play_backwards("Clickbait Select Start")
	else:
		score -= 5
	if score > GameManager.high_score:
		GameManager.high_score = score
		GameManager.save_game()


func _on_session_timer_timeout() -> void:
	
	$Path3D.curve.set_point_position(2, $Path3D/PathFollow3D/Clickbait.initial_position)
	can_move = false
	input_accept = false
	session_timeout_timer.start()
	$AnimationPlayer.play("Session Timeout")
	$"Camera3D/UI Manager/Sprite3D4/SubViewport/SessionEnd".label.text = "Score: " + str(score) + "\nHigh Score: " + str(GameManager.high_score)

func _on_session_timeout_timer_timeout() -> void:
	input_accept = true
	$AnimationPlayer.play("Clickbait Select Start")
	$AnimationPlayer.play_backwards("Session Timeout")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
