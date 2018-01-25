# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".login"
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    find_user
    redirect_to(root_url) unless @user == current_user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find_by(id: params[:id])
    redirect_to "/404" unless @user
  end
end
