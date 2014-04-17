?php
/*
 * Internal Administration Files and Custom Tweaks 
 * for THEME_NAME
 * 
 * 
 * @category   Internal
 * @package    Wordpress
 * @subpage    THEME_NAME
 * @author     Marc Radziwill <m@frischezeilen.de>
 * @author     Philipp Siegmund <p@frischezeilen.de>
 * @copyright  2014 - frischezeilen.de
 *
 */
?>


<?php
/*
 *	Remove menus
 *	---------------------------------------------------------------------
 *	to remove Plugins you need to make sure the Plugin Menu Name
 *	doesn't contain whitespaces
 *	---------------------------------------------------------------------
 * 
 * 	@TODO Compare with Codex function:
 *  http://codex.wordpress.org/Function_Reference/remove_submenu_page
 * 
 */

function remove_menus() {
	global $menu;
	global $current_user;
	get_currentuserinfo();
	
	if(is_admin() && !is_super_admin()){
		$restricted = array(
					__('Links'), 
					__('Custom Post Name'), 
					__('Comments'),
					// __('Appearance'),
					__('Plugins'),  
					__('Tools'), 
					__('Settings'), 
		);
	
	} else {
		$restricted = array(
					// __('Dashboard'),
					__('Pages'), 
					__('Media'), 
					__('Links'), 
					__('Custom Post Name'), 
					__('Comments'),
					// __('Appearance'),
					__('Plugins'), 
					__('Users'), 
					__('Tools'), 
					__('Settings'),
		);
	}
	
	if (!is_super_admin()) {	

		end($menu);

		// Unset restricted menu elements  
		while (prev($menu)) {
			$value = explode(' ', $menu[key($menu)][0]);
			if (in_array($value[0] != NULL ? $value[0] : "", $restricted)) {
				unset($menu[key($menu)]);
			}
		}

		$role_object = get_role('contributor');
		$role_object -> add_cap('edit_theme_options');

		global $submenu;
		
		// in wp-admin/menu.php schauen welches submenu ausgeblendet werden soll
		
		unset($submenu['themes.php'][5]);// Removes 'Themes'.
		unset($submenu['themes.php'][6]);// Removes 'Customize'.
		unset($submenu['options-general.php'][15]); // Removes 'Writing'.
		unset($submenu['options-general.php'][25]); // Removes 'Discussion'.
		unset($submenu['edit.php'][16]); // Removes Tags
		
		function remove_comments(){
	        global $wp_admin_bar;
	        $wp_admin_bar->remove_menu('comments');
		}
		add_action( 'wp_before_admin_bar_render', 'remove_comments' );


	}// end if
}
add_action('admin_menu', 'remove_menus');



function disable_auto_updates(){
	global $current_user;
	get_currentuserinfo();
	if ($current_user -> user_level < 10) {
		add_filter( 'pre_site_transient_update_plugins', create_function( '$a', "return null;" ) );
		add_action( 'init', create_function( '$a', "remove_action( 'init', 'wp_version_check' );" ), 2 );
		add_filter( 'pre_option_update_core', create_function( '$a', "return null;" ) );
	}
}
add_action('admin_menu', 'disable_auto_updates');

function remove_dashboard_widgets(){
  global$wp_meta_boxes;
  unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_plugins']);
  unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_recent_comments']);
  unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_primary']);
  unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_incoming_links']);
  unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_right_now']);
  unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_secondary']); 
}

add_action('wp_dashboard_setup', 'remove_dashboard_widgets');

function change_post_menu_label() {
    global $menu;
    global $submenu;
    $menu[5][0] = 'Aktuelles';
    $submenu['edit.php'][5][0] = 'Aktuelles';
    $submenu['edit.php'][10][0] = 'Erstellen';
    
    echo '';
}
function change_post_object_label() {
    global $wp_post_types;
    $labels = &$wp_post_types['post']->labels;
    $labels->name = 'Aktuelles';
    $labels->singular_name = 'Aktuelles';
    $labels->add_new = 'Neuer Beitrag';
    $labels->add_new_item = 'Neuer Beitrag';
    $labels->edit_item = 'Beitrag bearbeiten';
    $labels->new_item = 'Aktuelles';
    $labels->view_item = 'Beitrag ansehen';
    $labels->search_items = 'Beitrag suchen';
    $labels->not_found = 'keine Beiträge gefunden';
    $labels->not_found_in_trash = 'keine Beiträge im Papierkorb gefunden';
}
add_action( 'init', 'change_post_object_label' );
add_action( 'admin_menu', 'change_post_menu_label' );

function kb_login_logo() { ?>
    <style type="text/css">
        body.login div#login h1 a {
            background-image: url(<?php echo get_stylesheet_directory_uri(); ?>/img/logo.png);
            padding-bottom: 30px;
            background-size: 100%;
            width: 100%;
            margin-bottom: -10%;
        }
        .login #nav a, .login #backtoblog a {
            box-shadow: none;
    		color: #F3113C !important;
        }
        .login #nav a:hover, .login #backtoblog a:hover {
            color: #000000 !important;
        }
    </style>
<?php }
add_action( 'login_enqueue_scripts', 'kb_login_logo' );