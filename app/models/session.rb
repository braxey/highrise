class Session < ApplicationRecord
  trim_strings_only :email_address
  belongs_to :user
end
