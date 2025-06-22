@tool
extends EditorPlugin

const PLUGIN_PATH: String = 'res://addons/ui_controls_combo/';

const COMBO_LIST := [
	
	# Basic Combo
	
	[ 'UIcombo_StatusLabel', 'Control',
			preload( PLUGIN_PATH + 'basic_combo/status_label.gd' ),
			preload( PLUGIN_PATH + 'icon/status_label.png' ) ],
	[ 'UIcombo_ResourceLabel', 'Control',
			preload( PLUGIN_PATH + 'basic_combo/resource_label.gd' ),
			preload( PLUGIN_PATH + 'icon/resource_label.png' ) ],
	
	# Menu Combo
	
	[ 'MENUcombo_Button', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/button.gd' ),
			preload( PLUGIN_PATH + 'icon/button.png' ) ],
	[ 'MENUcombo_OptionButton', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/option_button.gd' ),
			preload( PLUGIN_PATH + 'icon/option_button.png' ) ],
	[ 'MENUcombo_Switch', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/switch.gd' ),
			preload( PLUGIN_PATH + 'icon/switch.png' ) ],
	[ 'MENUcombo_RadioButton', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/radio_button.gd' ),
			preload( PLUGIN_PATH + 'icon/radio_button.png' ) ],
	[ 'MENUcombo_Slider', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/slider.gd' ),
			preload( PLUGIN_PATH + 'icon/slider.png' ) ],
	[ 'MENUcombo_NodeHider', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/node_hider.gd' ),
			preload( PLUGIN_PATH + 'icon/node_hider.png' ) ],
	
	# Non Combo
	
	[ 'NONcombo_ResourceIndicator', 'Node2D',
			preload( PLUGIN_PATH + 'non_combo/resource_indicator.gd' ),
			preload( PLUGIN_PATH + 'icon/resource_indicator.png' ) ],
	
]

#func _enable_plugin():
#	add_autoload_singleton( LIB_NAME, PLUGIN_PATH + 'ui_controls_combo_lib.gd' );
#func _disable_plugin():
#	remove_autoload_singleton( LIB_NAME );
func _enter_tree():
	for item in COMBO_LIST:
		add_custom_type( item[0], item[1], item[2], item[3] );
func _exit_tree():
	for item in COMBO_LIST:
		remove_custom_type( item[0] );
