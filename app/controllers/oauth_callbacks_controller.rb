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
    User.where(email: auth.info.email.downcase).first_or_initialize.tap do |user|
      user.github_token = auth.credentials.token
      user.github_uid = auth.info.uid
      user.name = auth.info.name
      user.nickname = auth.info.nickname

      if invited_team(user.email) && (user.team.blank? || user.team.single?)
        user.team = invited_team(user.email)
        redeem_invite!(user.email)
      elsif user.team.blank? && ENV["DISALLOW_NEW_TEAMS"].blank?
        user.create_team!(name: "#{user.name}'s Team")
      elsif user.team.blank? && ENV["DISALLOW_NEW_TEAMS"].present?
        raise "No new teams"
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

  def invited_team(email)
    @invited_team ||= session_invite.try!(:team) || email_invite(email).try!(:team)
  end

  def redeem_invite!(email)
    Invite.where("lower(invites.to) = lower(?) OR code = ?", email, session[:invite_code]).each(&:redeem!)
  end

  def session_invite
    @session_invite ||= if session[:invite_code]
      Invite.find_by(code: session[:invite_code])
    end
  end

  def email_invite(email)
    @email_invite ||= Invite.where("lower(invites.to) = lower(?)", email).first
  end

  def new_session_path(scope)
    root_path
  end

  def auth
    request.env["omniauth.auth"]
  end
end
