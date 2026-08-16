extends CharacterBody3D

@export var target_node : Node3D = null

@export var ai_type : int = randi_range(0,6)

@onready var nav_mesh : NavigationAgent3D = $NavigationAgent3D

var is_moving : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Intialize Target Position
	nav_mesh.target_position = target_node.global_position
	
	#Randomize Target Position
	nav_mesh.target_position.x += randf() * 2 * (-1) ** randi_range(1, 2)
	#nav_mesh.target_position.y += randf() * 10
	nav_mesh.target_position.z += randf() * 2 * (-1) ** randi_range(1, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_moving:
		var next_point : Vector3 = nav_mesh.get_next_path_position()
		var direction : Vector3 = (next_point - global_position).normalized()
		velocity = direction * 5
		move_and_slide()

func _on_navigation_agent_3d_navigation_finished() -> void:
	velocity = Vector3.ZERO
	is_moving = false
