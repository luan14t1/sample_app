# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, only: %i(destroy show)

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.pages.user.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info_account_activation"
      redirect_to root_url
    else
      flash[:danger] = t ".signup_danger"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update_user_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_user_danger"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_user_success"
      redirect_to users_url
    else
      flash[:danger] = t ".delete_user_danger"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
