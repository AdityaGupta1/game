extends Control

var _paused;

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		_toggle_paused();
		
func _notification(event):
	if event == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		set_paused(true);

func set_paused(new_paused):
	if get_tree().paused and !_paused:
		get_tree().get_root().get_node("main/inventory").escape();
		return;
	
	if get_parent().has_node("title screen"):
		return;
	
	_paused = new_paused;
	
	get_tree().paused = _paused;
	
	if _paused:
		show();
	else:
		hide();

func _toggle_paused():
	set_paused(!_paused);