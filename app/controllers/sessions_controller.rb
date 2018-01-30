# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      flash[:success] = t ".account_login_success"
      login_success user
    else
      flash[:danger] = t ".invalid_user_danger"
      render :new
    end
  end

  def destroy
    flash[:success] = t ".logout_user_success"
    log_out if logged_in?
    redirect_to root_url
  end

  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_to user
  end
end
