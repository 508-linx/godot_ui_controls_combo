extends Control

# fun fact, MENUcombo breakdown to men_ucombo :D

@export var hider_node: Control;

func _ready():
	## example to create button by script
	# INFO 1. create and add to scene
	var node := Editor_UiControlsCombo_Menu_Button.new();
	add_child( node );
	# INFO 2. attach neccesary child node
	var btn := Button.new();
	btn.text = 'script created button';
	node.add_child( btn );
	# INFO 3. assign node
	node.node_button = btn;
	# INFO DONE. node already work
	# recomment to use instantiate PackedScene to skip create something like this every time
	btn.toggle_mode = true;
	node.combo_signal_button_pressed.connect( func(): print('you pressed script created button.') );
	node.combo_signal_button_released.connect( func(): print('you released script created button.') );
	node.set_anchors_and_offsets_preset(Control.PRESET_CENTER);
	node.position -= node.size * 0.5;

func _on_men_ucombo_button_3_combo_signal_button_pressed():
	print( 'Toggle Button Pressed' );

func _on_men_ucombo_button_3_combo_signal_button_released():
	print( 'Toggle Button Released' );


func _on_men_ucombo_button_4_combo_signal_button_pressed():
	print( 'Normal Button Pressed' );

func _on_men_ucombo_button_4_combo_signal_button_released():
	print( 'Normal Button Released' );


func _on_men_ucombo_button_5_combo_signal_button_pressed():
	print( 'You Pressed Me!' );


func _on_men_ucombo_button_7_combo_signal_button_released():
	print( 'You Released Me!' );


func _on_men_ucombo_button_6_combo_signal_button_pressed():
	print( 'You Should never see Me !' );


func _on_men_ucombo_button_combo_signal_button_pressed():
	print( 'Texture Button Pressed' );


func _on_men_ucombo_switch_combo_signal_button_pressed():
	print( 'Switch ON')


func _on_men_ucombo_radio_button_3_combo_signal_radio_changed(idx):
	print( 'radio changed to idx = ', idx )


func _on_men_ucombo_option_button_combo_signal_option_changed(idx):
	print( 'option changed to idx = ', idx )


func _on_men_ucombo_slider_combo_signal_value_changed(value):
	print( 'slider value changed to ', value )


func _on_men_ucombo_switch_combo_signal_switch_changed(state):
	hider_node.combo_button_pressed = state;
