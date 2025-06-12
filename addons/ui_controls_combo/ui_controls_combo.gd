@tool
extends EditorPlugin

const PLUGIN_PATH: String = 'res://addons/ui_controls_combo/';

const LIB_NAME := 'UiControlsComboLib';
const COMBO_LIST := [
	[ 'StatusLabel', 'Control',
			preload( PLUGIN_PATH + 'combo/status_label.gd' ),
			preload( PLUGIN_PATH + 'icon/status_label.png' ) ],
	[ 'IconLabel', 'Control',
			preload( PLUGIN_PATH + 'combo/icon_label.gd' ),
			preload( PLUGIN_PATH + 'icon/icon_label.png' ) ],
]

func _enable_plugin():
	add_autoload_singleton( LIB_NAME, PLUGIN_PATH + 'lib.gd' );
func _disable_plugin():
	remove_autoload_singleton( LIB_NAME );
func _enter_tree():
	for item in COMBO_LIST:
		add_custom_type( item[0], item[1], item[2], item[3] );
func _exit_tree():
	for item in COMBO_LIST:
		remove_custom_type( item[0] );
