extends Node3D

# Gets the minigame
@export var qte : Node = null

# AI Array
var ai_array : Array[Node3D]

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
	else:
		qte.enable()

func successful_qt():
	ai_array[0].queue_free()
	ai_array.remove_at(0)

func unsuccessful_qt():
	print("No!")
	ai_array[0]._detected_clickbait()
	ai_array.remove_at(0)
