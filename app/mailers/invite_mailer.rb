class InviteMailer < ActionMailer::Base
  default from: "noreply@customer-know.com"
  layout 'mail'

  def invite
    @inviter_name = "Steve Bussey"

    mail(to: "sb8244@cs.ship.edu", subject: "You've Been Invited to Customer Know!")
  end
end
