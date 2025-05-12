class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true, length: { minimum: 2 }
  scope :unread, -> { where(read: false) }

  def user
    User.where(email_address: email_address).first
  end
end
