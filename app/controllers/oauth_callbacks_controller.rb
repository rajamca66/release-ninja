class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = from_github(request.env["omniauth.auth"])

    sign_in(user) if user.persisted?

    redirect_to root_path
  end

  private

  def from_github(auth)
    User.where(email: auth.info.email).first_or_initialize.tap do |user|
      user.github_token = auth.credentials.token
      user.github_uid = auth.info.uid
      user.email = auth.info.email if user.email.blank?
      user.name = auth.info.name if user.name.blank?
      user.nickname = auth.info.nickname if user.nickname.blank?

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
end
