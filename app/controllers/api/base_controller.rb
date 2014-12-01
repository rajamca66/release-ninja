class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def current_team
    @current_team ||= current_user.try!(:team)
  end
end
