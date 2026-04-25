class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_nav_active, :set_construction

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def set_nav_active
    @nav_active = { home: 'active', dash: '' }
  end

  def set_construction
    @construction = under_construction?
  end

  def under_construction?
    !(Rails.env.test?) && (ENV['UNDER_CONSTRUCTION'] == 'true')
  end
end
