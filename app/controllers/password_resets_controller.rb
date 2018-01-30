# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :gets_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_send_success"
      redirect_to root_url
    else
      flash.now[:danger] = t ".invalid_email_danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, (t".validate"))
      render :edit
    elsif @user.update_attributes(user_params)
      update_user_success @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters
  def gets_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless @user&.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".expiration_reset_danger"
    redirect_to new_password_reset_url
  end

  def update_user_success _user
    log_in @user
    @user.update_attributes(reset_digest: nil)
    flash[:success] = t ".password_reset_success"
    redirect_to @user
  end
end
