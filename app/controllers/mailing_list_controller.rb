# frozen_string_literal: true

class MailingListController < ApplicationController
  allow_unauthenticated_access

  before_action :set_mailing_list_entity

  def confirm
    if @mailing_list_entity.blank?
      redirect_to root_path, alert: 'Something went wrong. Please try again.'
    elsif !@mailing_list_entity.may_confirm?
      redirect_to root_path, notice: 'It looks like you\'re already on the list.'
    end
  end

  def confirmation
    if @mailing_list_entity.blank?
      redirect_to root_path, alert: 'Something went wrong. Please try again.'
    elsif !@mailing_list_entity.may_confirm?
      redirect_to root_path, notice: 'It looks like you\'re already on the list.'
    end

    @mailing_list_entity.confirm!

    redirect_to root_path, notice: 'You are now confirmed for our mailing list!'
  end

  def unsubscribe
    @mailing_list_entity.destroy if @mailing_list_entity.present?

    redirect_to root_path, notice: 'Your email is no longer in our system.'
  end

  private

  def set_mailing_list_entity
    @mailing_list_entity = MailingListEntity.find(params[:code])
  end
end
