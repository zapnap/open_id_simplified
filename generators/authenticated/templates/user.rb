class User < ActiveRecord::Base
  has_many :identity_urls, :dependent => :destroy
  #validates_presence_of :name
end
