extends Node3D

class_name Clickbait

# Gets the minigame
@export var qte : qte = null

@export var spacebar : Sprite3D = null

#@onready var mesh: MeshInstance3D = $Area3D/MeshInstance3D

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
			#print("entered")
			ai_array.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is AI:
		if body.is_moving == false:
			#print("exited")
			ai_array.erase(body)

func _process(delta: float) -> void:
	qte.ai_array = ai_array
	if ai_array.size() == 0:
		qte.disable()
		can_enable_qte = false
		$Area3D/Sprite3D.modulate.a = 1
		$OmniLight3D.light_energy = 0
		spacebar.visible = false

	else:
		can_enable_qte = true
		#qte.enable()
		$Area3D/Sprite3D.modulate.a = 0.5
		$OmniLight3D.light_energy = 4
		if qte.enabled == false:
			spacebar.visible = true

	if Input.is_action_just_pressed("interaction") and can_enable_qte:
		qte.enable()
		spacebar.visible = false
	
	global_rotation.y = 0

func successful_qt():
	ai_array[0].queue_free()
	ai_array.remove_at(0)

func unsuccessful_qt():
	#print("No!")
	ai_array[0]._detected_clickbait()
	ai_array.remove_at(0)

func randomise():
	match randi_range(0, 2):
		0:
			$Area3D/Sprite3D.texture = load("res://Jahin's Part/Art/Clickbait/Discord Nitro Scam.png")
		1:
			$Area3D/Sprite3D.texture = load("res://Jahin's Part/Art/Clickbait/Free iPhone Scam.png")
		2:
			$Area3D/Sprite3D.texture = load("res://Jahin's Part/Art/Clickbait/Free Steam Gift Card Scam.png")
