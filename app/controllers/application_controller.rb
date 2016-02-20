class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  force_ssl unless: :ssl_not_required?
  protect_from_forgery with: :exception

  def index
    render text: "", layout: "ng"
  end

  def current_team
    @current_team ||= current_user.try!(:team)
  end

  def current_user
    @current_user ||=  super || if request.env['HTTP_X_ACCESS_TOKEN']
                                  User.find_by(access_token: request.env['HTTP_X_ACCESS_TOKEN'])
                                 end
  end

  private

  def ssl_not_required?
    !Rails.env.production? || request.path == "/healths"
  end
end
