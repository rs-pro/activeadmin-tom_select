ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span 'Welcome to ActiveAdmin Searchable Select Test App'
        small 'This is a test application for manually testing the searchable select functionality'
      end
    end

    panel 'Info' do
      ul do
        li "Posts: #{Post.count}"
        li "Categories: #{Category.count}"
        li "Users: #{User.count}"
        li "RGB Colors: #{RgbColor.count}"
      end
    end

    panel 'Recent Posts' do
      ul do
        Post.limit(5).map do |post|
          li link_to(post.title, admin_post_path(post))
        end
      end
    end
  end
end
