extends Node

var high_score : int

var save_path : String = "user://save_game.res"

func save_game():
	var new_save_game : SaveGame = SaveGame.new()
	new_save_game.high_score = high_score
	var error = ResourceSaver.save(new_save_game, save_path)

func load_game():
	if ResourceLoader.exists(save_path):
		var loaded_data = ResourceLoader.load(save_path).duplicate(true) as SaveGame
		if loaded_data:
			high_score = loaded_data.high_score
		else:
			print("No loaded data")
