extends Control

# fun fact, MENUcombo breakdown to men_ucombo :D

@export var hider_node: Control;

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
