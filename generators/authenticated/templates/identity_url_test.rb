require File.dirname(__FILE__) + '/../test_helper'

class IdentityUrlTest < Test::Unit::TestCase
  def test_should_create_identity_url
    assert_difference 'IdentityUrl.count' do
      identity_url = IdentityUrl.new(:url => "http://id.myopenid.com")
      assert identity_url.save
      assert !identity_url.new_record?
    end
  end

  def test_should_require_url
    assert_no_difference 'IdentityUrl.count' do
      identity_url = IdentityUrl.new
      assert !identity_url.save
      assert_equal identity_url.errors.on(:url), "can't be blank"
    end
  end

  def test_should_require_unique_url
    IdentityUrl.create(:url => "http://id.myopenid.com")
    assert_no_difference 'IdentityUrl.count' do
      identity_url = IdentityUrl.new(:url => "http://id.myopenid.com")
      assert !identity_url.save
      assert_equal identity_url.errors.on(:url), "has already been taken"
    end
  end
end
