class DkdSprintHookListener < Redmine::Hook::ViewListener
  # CSS + Sprint-Badge in der Top-Navigation
  render_on :view_layouts_base_html_head, partial: 'dkd_sprint/menu_bar'

  # Sidebar-Block auf der Startseite
  render_on :view_welcome_index_right, partial: 'dkd_sprint/sidebar'
end
