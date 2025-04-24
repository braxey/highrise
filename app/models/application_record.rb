class ApplicationRecord < ActiveRecord::Base
  include TrimStrings

  primary_abstract_class
end
