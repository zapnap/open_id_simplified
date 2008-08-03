class User < ActiveRecord::Base
  has_many :identity_urls, :dependent => :destroy
end
