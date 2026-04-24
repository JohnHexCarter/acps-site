# frozen_string_literal: true

class MailingListController < ApplicationController
  allow_unauthenticated_access

  before_action :set_mailing_list_entity

  def confirm
    unless @mailing_list_entity.present?
      redirect_to root_path, alert: 'Something went wrong. Please try again.'
    end
  end

  def confirmation
    unless @mailing_list_entity.present?
      redirect_to root_path, alert: 'Something went wrong. Please try again.'
    end

    @mailing_list_entity.confirm!

    redirect_to root_path, notice: 'You are now confirmed for our mailing list!'
  end

  private

  def set_mailing_list_entity
    @mailing_list_entity = MailingListEntity.find(params[:code])
  end
end
