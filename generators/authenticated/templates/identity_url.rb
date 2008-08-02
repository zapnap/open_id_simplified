class IdentityUrl < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :url
end
