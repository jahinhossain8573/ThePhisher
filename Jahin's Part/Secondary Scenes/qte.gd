extends Control

#Slider Speed
@export var slider_speed : float = 2.5

#Declaring markers as variables
@onready var start_marker: Marker2D = $Panel/StartMarker
@onready var end_marker: Marker2D = $Panel/EndMarker
@onready var trigger_zone_start_marker: Marker2D = $Panel/TriggerZoneStartMarker
@onready var trigger_zone_end_marker: Marker2D = $Panel/TriggerZoneEndMarker

#Declaring Panel and Slider as variables
@onready var panel: Panel = $Panel
@onready var slider_bar: Sprite2D = $Panel/SliderBar

#Slider Direction
var is_moving_right : bool = true

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if slider_bar.global_position.x >= end_marker.global_position.x:
		is_moving_right = false
	elif slider_bar.global_position.x <= start_marker.global_position.x:
		is_moving_right = true
		
	if is_moving_right:
		slider_bar.global_position.x += slider_speed
	else:
		slider_bar.global_position.x -= slider_speed
