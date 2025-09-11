class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern if respond_to?(:allow_browser)

  cattr_accessor :current_user

  helper_method :current_user
end
