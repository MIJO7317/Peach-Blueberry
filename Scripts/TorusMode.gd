extends Spatial


func start_game():
	$AnimationPlayer.play("ToStartCamera");
	yield(get_node("AnimationPlayer"), "animation_finished");
	get_tree().call_group("CameraMovement", "controll_on");
	$HorizontalMovement/VerticalMovement/Camera.edit = true;


func exit_game():
	get_tree().call_group("CameraMovement", "controll_off");
	$HorizontalMovement/VerticalMovement/Camera.edit = false;
	get_tree().call_group("CameraMovement", "go_to_start");
	$AnimationPlayer.play_backwards("ToStartCamera");
	delete_meshes();


func fold():
	get_node("Torus").visible = false;
	get_node("FoldUnfold/AnimationPlayer").play("fold");
	yield(get_node("FoldUnfold/AnimationPlayer"), "animation_finished");
	get_node("Torus").visible = true;


func unfold():
	get_node("Torus").visible = false;
	get_tree().call_group("CameraMovement", "go_to_start");
	get_node("FoldUnfold/AnimationPlayer").play("unfold");


func disappear():
	get_tree().call_group("PlayerMesh", "disappear");


func appear():
	get_tree().call_group("PlayerMesh", "appear");


func add_meshes():
	for i in range(Global.lattice_size):
		for j in range(Global.lattice_size):
			if Global.solver.GetElementBoard(i,j) == "NONE":
				continue;
			var mesh : Spatial;
			if Global.solver.GetElementBoard(i,j) == Global.first_player:
				mesh = load("res://Scenes/FirstPlayerMesh.tscn").instance();
			elif Global.solver.GetElementBoard(i,j) == Global.second_player:
				mesh = load("res://Scenes/SecondPlayerMesh.tscn").instance();
			mesh.translation = $HorizontalMovement/VerticalMovement/Camera.to_3d(Vector2(i, j));
			get_node("Meshes").add_child(mesh);


func delete_meshes():
	for child in get_node("Meshes").get_children():
		get_node("Meshes").remove_child(child);
