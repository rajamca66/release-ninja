class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = from_github(env["omniauth.auth"])

    sign_in(user) if user.persisted?

    redirect_to root_path
  end

  private

  def from_github(auth)
    User.first_or_initialize(email: auth.info.email).tap do |user|
      user.github_token = auth.credentials.token
      user.github_uid = auth.info.uid
      user.email = auth.info.email if user.email.blank?
      user.name = auth.info.name if user.name.blank?
      user.nickname = auth.info.nickname if user.nickname.blank?

      if user.team.blank?
        # Can check here if there is an invite code present in the session and assign to that team instead of creating
        user.create_team(name: "#{user.name}'s Team")
      end

      user.save
    end
  end

  def new_session_path(scope)
    root_path
  end
end
