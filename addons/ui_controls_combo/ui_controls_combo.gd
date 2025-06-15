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
			preload( PLUGIN_PATH + 'icon/status_label.png' ) ],
	
	# Menu Combo
	
	[ 'MENUcombo_Button', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/button.gd' ),
			preload( PLUGIN_PATH + 'icon/icon_label.png' ) ],
	[ 'MENUcombo_Switch', 'Control',
			preload( PLUGIN_PATH + 'menu_combo/switch.gd' ),
			preload( PLUGIN_PATH + 'icon/icon_label.png' ) ],
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
