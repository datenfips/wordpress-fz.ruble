require 'ruble'
require 'date'

# Change the Login Logo to whatever is under /img/logo.png

snippet 'change_login_logo()' do |s|
  s.expansion = '
  function change_login_logo() { ?>
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
add_action( \'login_enqueue_scripts\', \'change_login_logo\' );'
end

snippet 'change_admin_footer()' do |s|
  s.expression = '
  function change_admin_footer() {
    $user_info = get_userdata(1);
    echo \'<p>${1:Admin String} <a href=\'mailto:<?php $admin_email = get_option( \'admin_email\' ); ?>\'><?php echo $user_info->first_name . \' \' . $user_info->last_name; ?></a>.</p><p>© ' 
  
  s.expression += Date.today.strftime("%Y") 
  s.expression += ' <?php echo '' . get_option( \'blogname\' ); ?>.</p>\';
  }
add_filter(\'admin_footer_text\', \'change_admin_footer\');'



# Change the 'Post' menu item name

snippet 'change_post_menu_labels()' do |s|
  s.expansion = '
  function change_post_menu_label() {
    global $menu;
    global $submenu;
    $menu[5][0] = \'${1:New Lable}\';
    $submenu[\'edit.php\'][5][0] = \'${1:New Lable}\';
    $submenu[\'edit.php\'][10][0] = \'${2:Lable for \'Create\'}\';
    
    echo \'\';
}'
end

# Change the post item labels, goes 'hand in hand with change_post_menu_label()

snippet 'change_post_object_label()' do |s|
  s.expansion = '
function change_post_object_label() {
    global $wp_post_types;
    $labels = &$wp_post_types[\'post\']->labels;
    $labels->name = \'${1:New Name}\';
    $labels->singular_name = \'${2:New Single Name}\';
    $labels->add_new = \'${3:New Item}\';
    $labels->add_new_item = \'${3:New Item}\';
    $labels->edit_item = \'${4:Edit Item}\';
    $labels->new_item = \'${1:New Name}\';
    $labels->view_item = \'${5:View Item}\';
    $labels->search_items = \'${6:Search Item}\';
    $labels->not_found = \'${7:Found no items}\';
    $labels->not_found_in_trash = \'${8:No items in trash}\';
}
add_action( \'init\', \'change_post_object_label\' );'
end

# Hide restricted menu items in admin area

snippet "remove_restricted_menus()" do |snip|
  snip.expansion = '
/*
 *  Remove menus
 *  ---------------------------------------------------------------------
 *  to remove Plugins you need to make sure the Plugin Menu Name
 *  doesn\'t contain whitespaces
 *  ---------------------------------------------------------------------
 * 
 *  @TODO Compare with Codex function:
 *  http://codex.wordpress.org/Function_Reference/remove_submenu_page
 * 
 */

function remove_restricted_menus() {
  global $menu;
  global $current_user;
  get_currentuserinfo();
  
  /*
   * Add restricted menu items to $restricted array
   */

  if(is_admin() && !is_super_admin()){
    $restricted = array( );
  
  } else {
    $restricted = array( );
  }
  
  if (!is_super_admin()) {  

    end($menu);

    // Unset restricted menu elements  
    while (prev($menu)) {
      $value = explode(\' \', $menu[key($menu)][0]);
      if (in_array($value[0] != NULL ? $value[0] : "", $restricted)) {
        unset($menu[key($menu)]);
      }
    }

    $role_object = get_role(\'contributor\');
    $role_object -> add_cap(\'edit_theme_options\');

    global $submenu;
    
    // in wp-admin/menu.php schauen welches submenu ausgeblendet werden soll
    
    unset($submenu[\'themes.php\'][5]);// Removes \'Themes\'.
    unset($submenu[\'themes.php\'][6]);// Removes \'Customize\'.
    unset($submenu[\'options-general.php\'][15]); // Removes \'Writing\'.
    unset($submenu[\'options-general.php\'][25]); // Removes \'Discussion\'.
    unset($submenu[\'edit.php\'][16]); // Removes Tags
    
    function remove_comments(){
          global $wp_admin_bar;
          $wp_admin_bar->remove_menu(\'comments\');
    }
    add_action( \'wp_before_admin_bar_render\', \'remove_comments\' );


  }// end if
}
add_action(\'admin_menu\', \'remove_restricted_menus\');
'
end



# Disables the new Wordpress auto-update feature 

snippet 'disable_auto_updates()' do |s|
  s.expansion = '
function disable_auto_updates(){
  global $current_user;
  get_currentuserinfo();
  if ($current_user -> user_level < 10) {
    add_filter( \'pre_site_transient_update_plugins\', create_function( \'$a\', "return null;" ) );
    add_action( \'init\', create_function( \'$a\', "remove_action( \'init\', \'wp_version_check\' );" ), 2 );
    add_filter( \'pre_option_update_core\', create_function( \'$a\', "return null;" ) );
  }
}
add_action(\'admin_menu\', \'disable_auto_updates\');'
end

snippet 'remove_dashboard_widgets()' do |s|
  s.expansion = '
  function remove_dashboard_widgets(){
    
  global$wp_meta_boxes;
  
  unset($wp_meta_boxes[\'dashboard\'][\'normal\'][\'core\'][\'dashboard_plugins\']);
  unset($wp_meta_boxes[\'dashboard\'][\'normal\'][\'core\'][\'dashboard_recent_comments\']);
  unset($wp_meta_boxes[\'dashboard\'][\'side\'][\'core\'][\'dashboard_primary\']);
  unset($wp_meta_boxes[\'dashboard\'][\'normal\'][\'core\'][\'dashboard_incoming_links\']);
  unset($wp_meta_boxes[\'dashboard\'][\'normal\'][\'core\'][\'dashboard_right_now\']);
  unset($wp_meta_boxes[\'dashboard\'][\'side\'][\'core\'][\'dashboard_secondary\']); 
}
add_action(\'wp_dashboard_setup\', \'remove_dashboard_widgets\');'
end