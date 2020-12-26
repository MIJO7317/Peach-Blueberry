extends Node


var text_notice : String;
var player : String = "FirstPlayer";
var human : String;
var ai : String;
var first_player : String;
var second_player : String;
var player_type : String;
var player_number : int = 1;
var lattice_size : int = 15;
var matrix : Matrix = Matrix.new(Vector2(lattice_size, lattice_size));
var solver : TicTacToeSolver = TicTacToeSolver.new();
var epsilon : float = 0.001;
var is_win : bool = false;
var notice_number : int = 1;
var train : bool = true;
var hard : bool = true;
var begin_step : bool = true;


var game : Node;
var gui : Node;
var current_mode : Node = null;
var name_mode : String;


func exit():
	get_tree().quit();


func change_mode(var new_mode : String) -> void:
	name_mode = new_mode;
	if current_mode != null:
		game.remove_child(current_mode);
	current_mode = load("res://Scenes/" + name_mode + ".tscn").instance();
	game.add_child(current_mode);


func next_move() ->void:
	if player == "FirstPlayer":
		player = "SecondPlayer";
		player_number = 2;
		player_type = second_player;
	elif player == "SecondPlayer":
		player = "FirstPlayer";
		player_number = 1;
		player_type = first_player;
