# frozen_string_literal: true

class SiteController < ApplicationController
  allow_unauthenticated_access

  layout :check_for_dummy_page

  def index
  end

  def check_for_dummy_page
    @dummy ? 'dummy' : 'application'
  end
end
