class DkdSprintHookListener < Redmine::Hook::ViewListener
  # CSS + Sprint-Badge in der Top-Navigation
  render_on :view_layouts_base_html_head, partial: 'dkd_sprint/menu_bar'

  # Sidebar-Block auf der Startseite
  render_on :view_welcome_index_right, partial: 'dkd_sprint/sidebar'
end

# My-Page-Widget registrieren
Redmine::MyPage::Block.add('dkd_sprint_tracker') do |block|
  block.label = :label_dkd_sprint_tracker
  block.partial = 'dkd_sprint/my_page'
end if Redmine::MyPage::Block.respond_to?(:add)
