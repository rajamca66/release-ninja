class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    if current_user
      render text: "", layout: "ng"
    else
      check_for_invite
      render layout: "application"
    end
  end

  private

  def check_for_invite
    session[:invite_code] = params.fetch(:invite_code, nil)
  end
end
