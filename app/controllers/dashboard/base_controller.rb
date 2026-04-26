# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'

    before_action :populate_dash_objects

    def index
    end

    private

    def set_nav_active
      @nav_active = { home: '', dash: 'active' }
    end

    def populate_dash_objects
      mailer = DashObject.find_by(namespace: 'mailer')
      pages = DashObject.find_by(namespace: 'pages')
      profile = DashObject.find_by(namespace: 'profile')
      @dash_objects = [ mailer, pages, profile ]
    end
  end
end
