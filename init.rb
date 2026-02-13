require_relative 'lib/dkd_sprint_calculator'
require_relative 'lib/dkd_sprint_hook_listener'

Redmine::Plugin.register :redmine_dkd_sprint_tracker do
  name 'dkd Sprint Tracker'
  author 'dkd Internet Service GmbH'
  description 'Zeigt den aktuellen dkd-Sprint in der Redmine-Oberflaeche an'
  version '1.0.0'
  url 'https://github.com/dkd-dobberkau/redmine_dkd_sprint_tracker'
end
