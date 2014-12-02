class Api::InvitesController < Api::BaseController
  def create
    invite = current_user.invites.create(invite_params)

    if invite.persisted?
      InviteMailer.invite(invite).deliver
    end

    respond_with :api, invite
  end

  private

  def invite_params
    params.permit(:to).merge(team: current_team)
  end
end
