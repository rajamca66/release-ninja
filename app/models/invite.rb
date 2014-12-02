class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  before_create :assign_code
  validate :check_unique!

  def assign_code
    self.code = SecureRandom.hex(20)
  end

  def redeem!
    update!(redeemed: true)
  end

  def check_unique!
    if self.team.invites.where(to: self.to, redeemed: false).where.not(id: self.id).any?
      errors.add(:email, "has a pending invite")
    end
  end
end
