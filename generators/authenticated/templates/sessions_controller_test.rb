require 'test_helper'
require 'mocha'

class SessionsControllerTest < ActionController::TestCase
  def setup
    SessionsController.class_eval do
      def authenticate_with_open_id(identity_url = params[:openid_identifier], options = {}, &block) #:doc:
        if (identity_url == "http://valid.myopenid.com")
          yield(OpenIdAuthentication::Result[:successful], identity_url, {'email' => 'email@test.net', 'nickname' => 'nick'})
        else
          yield(OpenIdAuthentication::Result[:failed], identity_url, nil)
        end
      end
    end

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller = SessionsController.new
  end

  def test_should_render_login_form
    get :new
    assert_response :success
    assert_template "new"
    assert_select "form"
  end

  def test_should_rerender_login_form_if_openid_error
    post :create, :openid_identifier => "http://invalid.myopenid.com"
    assert_response :success
    assert_template "new"
  end

  def test_should_login_with_open_id
    user = User.new
    identity_url = IdentityUrl.new(:url => 'http://valid.myopenid.com', :user => user)
    IdentityUrl.stubs(:find_or_create_by_url).returns(identity_url)
    @controller.stubs(:assign_registration_attributes!).returns(true)

    @controller.expects(:current_user=).with(user)
    post :create, :openid_identifier => "http://valid.myopenid.com"
  end

  def test_login_should_redirect_on_success
    post :create, :openid_identifier => "http://valid.myopenid.com"
    assert_response :redirect
  end

  def test_should_use_sreg_data_if_available
    user = User.new
    identity_url = IdentityUrl.new(:url => 'http://valid.myopenid.com', :user => user)
    IdentityUrl.stubs(:find_or_create_by_url).returns(identity_url)

    user.expects(:nickname=).with('nick')
    user.expects(:email=).with('email@test.net')
    user.expects(:save).returns(true)
    post :create, :openid_identifier => "http://valid.myopenid.com"
  end

  def test_should_create_new_identity_url_and_user
    assert_difference('User.count') do
      post :create, :openid_identifier => "http://valid.myopenid.com"
    end
  end

  def test_should_logout
    @request.session[:user_id] = 1
    delete :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end
end
