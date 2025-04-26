class User < ApplicationRecord
  trim_strings_except :password, :password_confirmation

  NAME_REGEX = /\A[a-zA-Z\s'-]*\z/
  NAME_MESSAGE = "only allows letters, spaces, hyphens, and apostrophes"
  EMAIL_MESSAGE = "must be a valid email address"

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP, message: EMAIL_MESSAGE }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :first_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :last_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :is_active, inclusion: { in: [ true, false ] }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create_commit :send_welcome_email

  private
    def send_welcome_email
      UsersMailer.with(user: self).welcome.deliver_later
    end
end
