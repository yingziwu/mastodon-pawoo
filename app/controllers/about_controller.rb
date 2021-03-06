# frozen_string_literal: true

class AboutController < ApplicationController
  layout 'public'

  before_action :set_instance_presenter, only: [:show, :more, :terms]

  skip_before_action :check_user_permissions, only: [:more, :terms]

  include Pawoo::AboutControllerConcern

  def show
    @hide_navbar = true

    render 'pawoo/extensions/about/show', layout: 'application'
  end

  def more; end

  def terms; end

  private

  def new_user
    User.new.tap do |user|
      user.build_account
      user.build_invite_request
    end
  end

  helper_method :new_user

  def set_instance_presenter
    @instance_presenter = InstancePresenter.new
  end
end
