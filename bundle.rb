require 'ruble'

bundle do |bundle|
  bundle.display_name = 'wordpress-fz.ruble'
  bundle.author = 'My Name'
  bundle.copyright = <<END
(c) Copyright 2011 sample.org. Distributed under MIT license.
END

  bundle.description = <<END
Sample description
END

  # uncomment with the url to the git repo if one exists
  bundle.repository = 'git@github.com:datenfips/wordpress-fz.ruble.git'

  # Use Commands > Bundle Development > Insert Bundle Section > Menu
  # to easily add new sections
  bundle.menu 'wordpress-fz.ruble' do |menu|
    menu.command 'Swap Case'
    menu.command 'Sample Snippet'
    menu.separator
    menu.menu 'Admin Functions' do |sub_menu|
        sub_menu.command 'change_post_menu_label()'
        sub_menu.command 'change_post_object_labels()'
        sub_menu.command 'remove_restricted_menus()'
        sub_menu.command 'remove_dashboard_widgets()'
        sub_menu.separator
        sub_menu.command 'change_login_logo()'
        sub_menu.command 'change_admin_footer()'
        sub_menu.command 'disable_auto_updates()'
    end
  end
end