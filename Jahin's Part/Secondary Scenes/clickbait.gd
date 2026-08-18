extends Node3D

class_name Clickbait

# Gets the minigame
@export var qte : qte = null

@onready var mesh: MeshInstance3D = $Area3D/MeshInstance3D

var initial_position : Vector3 = Vector3.ZERO

# AI Array
var ai_array : Array[AI]

# Clickbait Type
var type : int = 0

# Ability to enable QTE
var can_enable_qte : bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is AI:
		if body.is_moving == false:
			print("entered")
			ai_array.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is AI:
		if body.is_moving == false:
			print("exited")
			ai_array.erase(body)

func _process(delta: float) -> void:
	qte.ai_array = ai_array
	if ai_array.size() == 0:
		qte.disable()
		can_enable_qte = false
	else:
		can_enable_qte = true
		#qte.enable()
		
	if Input.is_action_just_pressed("interaction") and can_enable_qte:
		qte.enable()

func successful_qt():
	ai_array[0].queue_free()
	ai_array.remove_at(0)

func unsuccessful_qt():
	print("No!")
	ai_array[0]._detected_clickbait()
	ai_array.remove_at(0)

func type_change():
	match type:
		0:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 0.tres"))
		1:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 1.tres"))
		2:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 2.tres"))
		3:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 3.tres"))
		4:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 4.tres"))
		5:
			mesh.mesh.surface_set_material(0, load("res://Jahin's Part/Materials/Clickbait 5.tres"))
