class IdentityUrl < ActiveRecord::Base
  belongs_to :user
  validates_presence_of   :url
  validates_uniqueness_of :url
end
