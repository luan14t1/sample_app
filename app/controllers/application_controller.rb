# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper
  def hello
    render html: "Hello, world!"
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
