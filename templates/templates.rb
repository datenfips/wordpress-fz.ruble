require 'ruble'

template "WP Custom Admin Functions" do |t|
  t.filetype = "*.php"
  t.invoke do |context|
    raw_contents = IO.read("#{ENV['TM_BUNDLE_PATH']}/templates/fz_admin_functions.php")
    raw_contents.gsub(/\$\{([^}]*)\}/) {|match| ENV[match[2..-2]] }
  end
end