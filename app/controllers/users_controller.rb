# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(slug: params[:username])
  end
end
