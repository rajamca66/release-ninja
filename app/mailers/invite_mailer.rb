class InviteMailer < ActionMailer::Base
  default from: "noreply@customer-know.com"
  layout 'mail'

  def invite(invite)
    @inviter_name = invite.user.name
    @code = invite.code

    mail(to: invite.to, subject: "You've Been Invited to Customer Know!")
  end
end
