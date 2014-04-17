<?php
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
add_action( 'login_enqueue_scripts', 'change_login_logo' );

function change_admin_footer() {
	$user_info = get_userdata(1);
      
    echo '<p> STRING <a href=\'mailto:<?php $admin_email = get_option( \'admin_email\' ); ?> \'><?php echo $user_info->first_name . \' \' . $user_info->last_name; ?></a>.</p><p>© 2014 <?php $admin_email = get_option( \'blogname\' ); ?></p>';
}
add_filter('admin_footer_text', 'change_admin_footer');