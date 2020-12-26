extends Control


var active := true;
var win_window := false;
var notice_finished := false;


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		if active:
			$GameName.visible = true;
			$ExitButton.disabled = false;
			$PlayButton.disabled = false;
			$DifficultButton.disabled = false;
			$ModeButton.disabled = true;
			$ChoseColorLabel.visible = false;
			$FirstPlayerButton.disabled = true;
			$SecondPlayerButton.disabled = true;
			if Global.name_mode == "TorusMode":
				Global.current_mode.disappear();
				yield(get_tree().create_timer(0.6), "timeout");
				Global.current_mode.exit_game();
			elif Global.name_mode == "LatticeMode":
				$ModeButton.texture_normal = load("res://Resures/LatticeButton.png");
				Global.change_mode("TorusMode");
				Global.current_mode.fold();
				Global.current_mode.exit_game();
			Global.begin_step = true;
			Global.is_win = false;
			Global.solver.FillBoard("NONE");
			Global.player = "FirstPlayer";
			Global.player_number = 1;
			if Global.notice_number <= 3 and notice_finished:
				pop_notice();


func _on_ExitButton_pressed():
	Global.exit();


func _on_PlayButton_pressed():
	$GameName.visible = false;
	$ExitButton.disabled = true;
	$PlayButton.disabled = true;
	$DifficultButton.disabled = true;
	$ChoseColorLabel.visible = true;
	$FirstPlayerButton.disabled = false;
	$SecondPlayerButton.disabled = false;


func _on_ModeButton_pressed():
	if active:
		active = false;
		$ModeButton.disabled = true;
		if Global.name_mode == "TorusMode":
			$ModeButton.texture_normal = load("res://Resures/TorusButton.png");
			Global.current_mode.disappear();
			yield(get_tree().create_timer(0.6), "timeout");
			Global.current_mode.unfold();
			yield(get_tree().create_timer(1.1), "timeout");
			Global.change_mode("LatticeMode");
			Global.current_mode.add_sprites();
			Global.current_mode.appear();
		elif Global.name_mode == "LatticeMode":
			$ModeButton.texture_normal = load("res://Resures/LatticeButton.png");
			Global.current_mode.disappear();
			yield(get_tree().create_timer(0.6), "timeout");
			Global.change_mode("TorusMode");
			Global.current_mode.fold();
			yield(get_tree().create_timer(1.1), "timeout");
			Global.current_mode.add_meshes();
			Global.current_mode.appear();
		$ModeButton.disabled = false;
		active = true;


func _on_SecondPlayerButton_pressed():
	Global.first_player = "AI";
	Global.second_player = "HUMAN";
	Global.human = "SecondPlayer";
	Global.ai = "FirstPlayer";
	Global.player_type = Global.first_player;
	Global.current_mode.start_game();
	$ModeButton.disabled = false;
	$ChoseColorLabel.visible = false;
	$FirstPlayerButton.disabled = true;
	$SecondPlayerButton.disabled = true;
	if Global.notice_number == 1:
		push_notice("Use left click to move");
	if Global.notice_number == 2:
		push_notice("Use double click to make move");


func _on_FirstPlayerButton_pressed():
	Global.first_player = "HUMAN";
	Global.second_player = "AI";
	Global.human = "FirstPlayer";
	Global.ai = "SecondPlayer";
	Global.player_type = Global.first_player;
	Global.current_mode.start_game();
	$ModeButton.disabled = false;
	$ChoseColorLabel.visible = false;
	$FirstPlayerButton.disabled = true;
	$SecondPlayerButton.disabled = true;
	if Global.notice_number == 1:
		push_notice("Use left click to move");


func win_open(var player : String):
	Global.is_win = true;
	win_window = true;
	active = false;
	if player == Global.first_player:
		$TextureRect.texture = load("res://Resures/PeachWin.png");
	if player == Global.second_player:
		$TextureRect.texture = load("res://Resures/BlueBerryWin.png");
	if player == "DRAW":
		$TextureRect.texture = load("res://Resures/Draw.png");
	$TextureRect.visible = true;


func win_close():
	win_window = false;
	active = true;
	$TextureRect.visible = false;


func push_notice(var s : String):
	$AnimationPlayer.play("start_notice");
	yield(get_tree().create_timer(1.0), "timeout");
	$Notice.text = s;
	notice_finished = true;


func pop_notice():
	$Notice.text = "";
	$AnimationPlayer.play_backwards("start_notice");
	notice_finished = false;


func _on_DifficultButton_toggled(button_pressed):
	if button_pressed:
		Global.hard = false;
	else:
		Global.hard = true;
