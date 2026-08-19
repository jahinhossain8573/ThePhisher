extends Control

class_name qte

signal QuickTimeSuccess
signal QuickTimeFailure

# Slider Speed
@export var slider_speed : float = 2.5

# Minigame Status
var enabled : bool = false

# Declaring markers as variables
@onready var start_marker: Marker2D = $Panel/StartMarker
@onready var end_marker: Marker2D = $Panel/EndMarker
@onready var trigger_zone_start_marker: Marker2D = $Panel/TriggerZoneStartMarker
@onready var trigger_zone_end_marker: Marker2D = $Panel/TriggerZoneEndMarker

#InteractionZone ColorRect
@onready var interaction_zone: ColorRect = $Panel/InteractionZone

# Declaring Panel and Slider as variables
@onready var panel: Panel = $Panel
@onready var slider_bar: Sprite2D = $Panel/SliderBar

# AI Array from Clickbait
var ai_array : Array[AI] = []

# Slider Direction
var is_moving_right : bool = true

# QTE Bar Length
var qte_bar_length : int = 0

# Trigger Zone Length
var trigger_zone_length : int = 0

func _ready() -> void:
	disable()
	qte_bar_length = end_marker.global_position.x - start_marker.global_position.x

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if enabled:
		if slider_bar.global_position.x >= end_marker.global_position.x:
			is_moving_right = false
		elif slider_bar.global_position.x <= start_marker.global_position.x:
			is_moving_right = true
		
		if is_moving_right:
			slider_bar.global_position.x += slider_speed
		else:
			slider_bar.global_position.x -= slider_speed
	
		if Input.is_action_just_pressed("interaction"):
			if slider_bar.global_position.x >= trigger_zone_start_marker.global_position.x and slider_bar.global_position.x <= trigger_zone_end_marker.global_position.x:
				#print("Superb")
				QuickTimeSuccess.emit()
			else:
				#print("Wrong Click")
				QuickTimeFailure.emit()

func enable():
	visible = true
	enabled = true
	match ai_array[0].ai_type:
		0:
			trigger_zone_length = randi_range(qte_bar_length/4, qte_bar_length/2)
		1:
			trigger_zone_length = randi_range(qte_bar_length/5, qte_bar_length/8)
		2:
			trigger_zone_length = randi_range(qte_bar_length/15, qte_bar_length/10)
	 
	trigger_zone_start_marker.global_position.x = randi_range(start_marker.global_position.x, start_marker.global_position.x+qte_bar_length-trigger_zone_length)
	interaction_zone.global_position.x = trigger_zone_start_marker.global_position.x
	interaction_zone.size.x = trigger_zone_length

func disable():
	visible = false
	enabled = false
