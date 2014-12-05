class InviteMailer < ActionMailer::Base
  default from: "invites@therelease.ninja"
  layout 'mail'

  def invite(invite)
    @inviter_name = invite.user.name
    @code = invite.code

    mail(to: invite.to, subject: "You've Been Invited to Customer Know!")
  end
end
