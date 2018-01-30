# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
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
    if user.activated?
      user_active user
    else
      flash[:warning] = t ".account_not_active"
      redirect_to root_url
    end
  end

  def user_active user
    flash[:success] = t ".account_login_success"
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
