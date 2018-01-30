# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".activation_account_success"
      redirect_to user
    else
      flash[:danger] = t ".invalid_link_danger"
      redirect_to root_url
    end
  end
end
