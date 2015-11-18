class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  force_ssl unless: :ssl_not_required?
  protect_from_forgery with: :exception

  def index
    if current_user
      render text: "", layout: "ng"
    else
      check_for_invite
      @invite = invite
      render layout: "application"
    end
  end

  def current_team
    @current_team ||= current_user.try!(:team)
  end

  def current_user
    @current_user ||=  super || if params[:access_token]
                                  User.find_by(access_token: params[:access_token])
                                 end
  end

  private

  def ssl_not_required?
    !Rails.env.production? || request.path == "/healths"
  end

  def check_for_invite
    session[:invite_code] = params.fetch(:invite_code, nil)
  end

  def invite
    @invite ||= Invite.find_by(code: session[:invite_code]) if session[:invite_code]
  end
end
