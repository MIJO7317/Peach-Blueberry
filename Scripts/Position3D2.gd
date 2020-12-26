extends Position3D


var controlled = true;
var to_start = false;
var to_cell = false;
var new_basis : Basis;
var current_rotation;
var interpolate_t;
var mouse_sensitivity = 0.002;


func controll_on():
	controlled = true;


func controll_off():
	controlled = false;


func go_to_start():
	to_start = true;
	current_rotation = self.rotation;
	interpolate_t = 0.0;


func go_to_cell(var indexes : Vector2) -> void:
	var angle : float = 2 * PI * indexes.x / Global.lattice_size + PI / Global.lattice_size;
	new_basis = Basis(Vector3(0, 1, 0), angle);
	interpolate_t = 0.0;
	to_cell = true;


func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("ui_mouse_left") and controlled:
		rotate_y(-event.relative.x*mouse_sensitivity);
		if Global.notice_number == 1:
			Global.gui.pop_notice();
			Global.gui.push_notice("Use double click to make move");
			Global.notice_number = 2;


func _process(delta):
	if to_start:
		self.rotation = current_rotation - current_rotation*interpolate_t;
		interpolate_t += delta;
		if interpolate_t > 1:
			self.rotation = Vector3(0,0,0);
			to_start = false;
	if to_cell:
		self.transform.basis = self.transform.basis.slerp(new_basis, interpolate_t);
		interpolate_t += delta;
		if interpolate_t > 1:
			self.transform.basis = new_basis;
			to_cell = false;
