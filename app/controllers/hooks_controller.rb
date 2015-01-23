class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def perform
    render json: true
  end
end
