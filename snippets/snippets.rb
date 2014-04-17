require 'ruble'

snippet 'Insert localized String ' do |s|
  s.trigger = 'wplocs'
  s.expansion = '__${1:namespace}(\'${2:String}\'),'
end

# Use Commands > Bundle Development > Insert Bundle Section > Snippet
# to easily add new snippets