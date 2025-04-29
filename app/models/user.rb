class User < ApplicationRecord
  trim_strings_except :password, :password_confirmation

  NAME_REGEX = /\A[a-zA-Z\s'-]*\z/
  NAME_MESSAGE = "only allows letters, spaces, hyphens, and apostrophes"
  EMAIL_MESSAGE = "must be a valid email address"

  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :role, optional: true
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :organization_invitations, foreign_key: :invited_by, dependent: :destroy

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP, message: EMAIL_MESSAGE }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :first_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :last_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create_commit :send_welcome_email

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]&.upcase}#{last_name[0]&.upcase}"
  end

  private
    def send_welcome_email
      UsersMailer.with(user: self).welcome.deliver_later
    end
end
