extends Camera2D

var edit := true;
var lattice_n := Global.lattice_size;
var controlled := true;
var mouse_sensitivity := 0.5;

func to_parallax(position : Vector2) -> Vector2:
	if position.x>0:
		position.x -= int(position.x/get_viewport().size.x)*get_viewport().size.x;
	else:
		position.x -= (int(position.x/get_viewport().size.x)-1)*get_viewport().size.x;
	if position.y>0:
		position.y -= int(position.y/get_viewport().size.y)*get_viewport().size.y;
	else:
		position.y -= (int(position.y/get_viewport().size.y)-1)*get_viewport().size.y;
	return position;

func to_lattice(indexes : Vector2) -> Vector2:
	var position : Vector2;
	position.x = indexes.x * get_viewport().size.x / lattice_n;
	position.y = indexes.y * get_viewport().size.y / lattice_n;
	var offset : Vector2 = get_viewport().size / lattice_n / 2;
	return position + offset;

func get_indexes(position : Vector2) -> Vector2:
	var indexes : Vector2;
	indexes.x = int(position.x*lattice_n/get_viewport().size.x);
	indexes.y = int(position.y*lattice_n/get_viewport().size.y);
	return indexes;


func add_sprite(var indexes : Vector2) -> bool:
	if(Global.solver.GetElementBoard(indexes.x, indexes.y) == "NONE"):
		Global.solver.SetElementBoard(indexes.x, indexes.y, Global.player_type);
		var sprite : Node2D = load("res://Scenes/" + Global.player + "Sprite.tscn").instance();
		sprite.position = to_lattice(indexes);
		get_node("../ParallaxBackground/ParallaxLayer2/Sprites").add_child(sprite);
		edit = false;
		Global.gui.active = false;
		sprite.appear();
		yield(get_tree().create_timer(0.6), "timeout");
		edit = true;
		Global.gui.active = true;
		var winner : String = Global.solver.WhoWin(5);
		if winner != "NONE":
			Global.gui.win_open(winner);
		else:
			Global.next_move();
		return true;
	return false;


func _input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT) and event.is_pressed() and event.doubleclick and Global.gui.win_window:
		Global.gui.win_close();
		if Global.notice_number == 3:
			Global.gui.push_notice("Use ESC to restart");
	if event is InputEventMouseMotion and Input.is_action_pressed("ui_mouse_left") and controlled:
		position+=Vector2(-event.relative.x*mouse_sensitivity, -event.relative.y*mouse_sensitivity);
		if Global.notice_number == 1:
			Global.gui.pop_notice();
			Global.gui.push_notice("Use double click to make move");
			Global.notice_number = 2;
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT) and event.is_pressed() and event.doubleclick:
		if Global.player == Global.human and edit:
			Global.begin_step = false;
			var mouse_position : Vector2 = get_viewport().get_mouse_position();
			var parallax_position : Vector2 = to_parallax(mouse_position+position);
			var indexes : Vector2 = get_indexes(parallax_position);
			add_sprite(indexes);
			if Global.notice_number == 2:
				Global.gui.pop_notice();
				Global.notice_number = 3;


func _process(delta):
	if Global.is_win:
		edit = false;
	if Global.player == Global.ai and edit:
		var indexes : Vector2 = Global.solver.NextAIMove(Global.hard);
		add_sprite(indexes);
