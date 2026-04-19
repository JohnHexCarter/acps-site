class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_nav_active

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def set_nav_active
    @nav_active = { home: 'active', dash: '' }
  end
end
