extends Node2D


onready var parallax = $ParallaxBackground;


func disappear() -> void:
	get_tree().call_group("PlayerSprite", "disappear");


func appear() -> void:
	get_tree().call_group("PlayerSprite", "appear");


func add_sprites():
	for i in range(Global.lattice_size):
		for j in range(Global.lattice_size):
			if Global.solver.GetElementBoard(i,j) == "NONE":
				continue;
			var sprite : Node2D;
			if Global.solver.GetElementBoard(i,j) == Global.first_player:
				sprite = load("res://Scenes/FirstPlayerSprite.tscn").instance();
			elif Global.solver.GetElementBoard(i,j) == Global.second_player:
				sprite = load("res://Scenes/SecondPlayerSprite.tscn").instance();
			sprite.position = $Camera2D.to_lattice(Vector2(i, j));
			get_node("ParallaxBackground/ParallaxLayer2/Sprites").add_child(sprite);
