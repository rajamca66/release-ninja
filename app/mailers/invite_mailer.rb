class InviteMailer < ActionMailer::Base
  default from: "noreply@customer-know.com"
  layout 'mail'

  def invite(from_user, to_email)
    @inviter_name = from_user.name

    mail(to: to_email, subject: "You've Been Invited to Customer Know!")
  end
end
