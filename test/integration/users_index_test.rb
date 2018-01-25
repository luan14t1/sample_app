# frozen_string_literal: true

require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end
