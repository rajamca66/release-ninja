class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  def authenticate_user!
    return if current_user

    render json: { error: "You need to sign in or sign up before continuing." }, status: :unauthorized
  end
end
