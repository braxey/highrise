class User < ApplicationRecord
  include HasPermissions
  trim_strings_except :password, :password_confirmation

  NAME_REGEX = /\A[a-zA-Z\s'-]*\z/
  NAME_MESSAGE = "only allows letters, spaces, hyphens, and apostrophes"
  EMAIL_MESSAGE = "must be a valid email address"

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :organization_invitations, foreign_key: :invited_by, dependent: :destroy
  has_one_attached :avatar

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP, message: EMAIL_MESSAGE }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :first_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :last_name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validate :acceptable_image_type
  validate :acceptable_image_size

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create_commit :send_welcome_email

  def notifications
    Notification.where(email_address: email_address)
  end

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

    def acceptable_image_type
      return unless avatar.attached?
      return if avatar.content_type.in?(%w[image/png image/jpeg])
      errors.add(:avatar, "must be a PNG or JPG")
    end

    def acceptable_image_size
      return unless avatar.attached?
      return unless avatar.byte_size > 3.megabyte
      errors.add(:avatar, "must be less than 3MB")
    end
end
