extends CharacterBody3D

class_name AI

# Movement Target
var target_node : AssemblyPoint = null

# AI Category
var ai_type : int = 0

# Navigation Agent
@onready var nav_mesh : NavigationAgent3D = $NavigationAgent3D



# AI State of Motion
var is_moving : bool = true

# Initial Position
var initial_position : Vector3 = Vector3.ZERO

# Clickbait Detection State
var is_detected_clickbait = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Intialize Target Position
	nav_mesh.target_position = target_node.global_position
	
	# Randomize Target Position
	nav_mesh.target_position.x += randf() * 2 * (-1) ** randi_range(1, 2)
	nav_mesh.target_position.z += randf() * 2 * (-1) ** randi_range(1, 2)
	
	$Sprite3D.global_position.y = $Sprite3D.global_position.y + randi_range(-1, 1)
	
	ai_type = target_node.assembly_points[randi_range(0, 5)]
	match ai_type:
		0:
			$Sprite3D/SubViewport/GenAlpha.visible = true
			$Sprite3D/SubViewport/GenAlpha2.visible = false
			$Sprite3D/SubViewport/GenAlpha3.visible = false
		1:
			#mesh_instance_3d.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/AI 1.tres").duplicate())
			$Sprite3D/SubViewport/GenAlpha.visible = false
			$Sprite3D/SubViewport/GenAlpha2.visible = true
			$Sprite3D/SubViewport/GenAlpha3.visible = false
		2:
			#mesh_instance_3d.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/AI 2.tres").duplicate())
			$Sprite3D/SubViewport/GenAlpha.visible = false
			$Sprite3D/SubViewport/GenAlpha2.visible = false
			$Sprite3D/SubViewport/GenAlpha3.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# AI Movement
	if is_moving:
		var next_point : Vector3 = nav_mesh.get_next_path_position()
		var direction : Vector3 = (next_point - global_position).normalized()
		velocity = direction * 5
		move_and_slide()

func _on_navigation_agent_3d_navigation_finished() -> void:
	velocity = Vector3.ZERO
	is_moving = false
	if is_detected_clickbait:
		queue_free()

func _detected_clickbait():
	nav_mesh.target_position = initial_position
	is_moving = true
	is_detected_clickbait = true
