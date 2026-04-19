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
      @dash_objects = []
    end
  end
end
