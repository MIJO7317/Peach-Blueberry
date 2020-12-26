extends Camera


const ray_length = 1000;
var R = 1.5;
var r = 0.5;
var mouse_position_3d = null;
var edit : bool = true;


func to_uv(var coordinates : Vector3) -> Vector2:
	#Get U coordinate:
	var phi : float;
	if abs(coordinates.z) < Global.epsilon:
		if coordinates.x > 0:
			phi = PI/2;
		else:
			phi = -PI/2;
	elif coordinates.z > 0:
		phi = atan(coordinates.x/coordinates.z);
	elif coordinates.z < 0:
		phi = PI + atan(coordinates.x/coordinates.z);
	if phi < 0 :
		phi += 2*PI;
	var u : float = phi * R;
	
	#Get V coordinate:
	var teta : float;
	if sqrt(pow(coordinates.x,2) + pow(coordinates.z,2)) > R:
		teta = -asin(coordinates.y/r);
	else:
		teta = PI + asin(coordinates.y/r);
	if teta < 0:
		teta += 2*PI;
	var v : float = teta * r;
	
	return Vector2(u, v);


func get_indexes(var uv : Vector2) -> Vector2:
	return Vector2(int(uv.x / (2 * PI * R) * Global.lattice_size), int(uv.y / (2 * PI * r) * Global.lattice_size));


func to_3d(var indexes : Vector2) -> Vector3:
	var phi : float = 2 * PI * indexes.x / Global.lattice_size + PI / Global.lattice_size;
	var teta : float = 2 * PI * indexes.y / Global.lattice_size + PI / Global.lattice_size;
	var x : float = (R + r * cos(teta)) * sin(phi);
	var y : float = -r * sin(teta);
	var z : float = (R + r * cos(teta)) * cos(phi);
	return Vector3(x, y, z);


func add_mesh(var indexes : Vector2) -> bool:
	if(Global.solver.GetElementBoard(indexes.x, indexes.y) == "NONE"):
		Global.solver.SetElementBoard(indexes.x, indexes.y, Global.player_type);
		var mesh : Spatial = load("res://Scenes/" + Global.player + "Mesh.tscn").instance();
		mesh.translation = to_3d(indexes);
		get_node("../../../Meshes").add_child(mesh);
		get_tree().call_group("CameraMovement", "controll_off");
		edit = false;
		Global.gui.active = false;
		get_tree().call_group("CameraMovement", "go_to_cell", indexes);
		mesh.appear();
		yield(get_tree().create_timer(0.6), "timeout");
		get_tree().call_group("CameraMovement", "controll_on");
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
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT) and event.is_pressed() and event.doubleclick:
		if mouse_position_3d and Global.player == Global.human and edit:
			Global.begin_step = false;
			var indexes : Vector2 = get_indexes(to_uv(mouse_position_3d));
			add_mesh(indexes);
		if Global.notice_number == 2:
			Global.gui.pop_notice();
			Global.notice_number = 3;


func _physics_process(delta):
	if Global.is_win:
		edit = false;
	var space_state = get_world().direct_space_state;
	var mouse_position = get_viewport().get_mouse_position();
	var ray_origin = self.project_ray_origin(mouse_position);
	var ray_end = ray_origin + self.project_ray_normal(mouse_position)*ray_length;
	var intersection = space_state.intersect_ray(ray_origin, ray_end);
	if intersection:
		mouse_position_3d = intersection.position;
	else:
		mouse_position_3d = null;
	if Global.player == Global.ai and edit:
		if Global.begin_step:
			add_mesh(Vector2(Global.lattice_size/2, Global.lattice_size/2));
			Global.begin_step = false;
		else:
			var indexes : Vector2 = Global.solver.NextAIMove(Global.hard);
			add_mesh(indexes);
