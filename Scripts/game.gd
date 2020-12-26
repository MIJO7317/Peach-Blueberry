extends Control


func _ready():
	Global.solver.SetBoardSize(Global.lattice_size);
	Global.solver.FillBoard("NONE");
	Global.game = self;
	Global.gui = $CanvasGUI/GUI;
	Global.change_mode("TorusMode");
	Global.current_mode.exit_game();
	Global.current_mode.fold();
