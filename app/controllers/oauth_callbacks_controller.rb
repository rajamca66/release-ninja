class OauthCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    if params[:provider] == "github"
      github
    elsif params[:provider] == "google_oauth2"
      google
    end
  end

  private

  def github
    user = from_github

    sign_in(user) if user.persisted?
    session[:invite_code] = nil

    redirect_to root_path
  end


  def google
    reviewer = from_google

    sign_in(reviewer) if reviewer.persisted?

    redirect_to root_path
  end

  def from_github
    User.where(email: auth.info.email).first_or_initialize.tap do |user|
      user.github_token = auth.credentials.token
      user.github_uid = auth.info.uid
      user.email = auth.info.email if user.email.blank?
      user.name = auth.info.name
      user.nickname = auth.info.nickname

      if user.team.blank?
        if invited_team
          user.team = invited_team
          invite.redeem!
        else
          user.create_team!(name: "#{user.name}'s Team")
        end
      end

      user.save
    end
  end

  def from_google
    Reviewer.where(email: auth.info.email).first_or_initialize.tap do |user|
      user.email = auth.info.email if user.email.blank?
      user.name = auth.info.name
      user.save
    end
  end

  def invited_team
    invite.team if invite
  end

  def invite
    @invite ||= if session[:invite_code]
      Invite.find_by(code: session[:invite_code])
    end
  end

  def new_session_path(scope)
    root_path
  end

  def auth
    request.env["omniauth.auth"]
  end
end
