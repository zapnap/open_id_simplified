class SessionsController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
  end

  def create
    @open_id_url = params[:openid_identifier]
    if request.post? || using_open_id?
      authenticate_with_open_id(@open_id_url,
          :optional => [:nickname, :email]) do |result, identity_url, registration|
        if !result.successful?
          flash.now[:error] = result.message
          render(:action => 'new')
        else
          identity_url_model = IdentityUrl.find_or_create_by_url(identity_url)
          if identity_url_model.user.nil?
            flash.now[:notice] = "Thanks for signing up!"
            identity_url_model.create_user && identity_url_model.save
          end

          self.current_user = identity_url_model.user
          assign_registration_attributes!(registration)
          redirect_to('/')
        end
      end
    else
      render(:action => 'new')
    end
  end

  def destroy
    self.current_user = nil
    redirect_to('/')
  end

private

  # registration is a hash containing the valid sreg keys given above
  # use this to map them to fields of your user model
  def assign_registration_attributes!(registration)
    model_to_registration_mapping.each do |model_attribute, registration_attribute|
      unless registration[registration_attribute].blank?
        @current_user.send("#{model_attribute}=", registration[registration_attribute])
      end
    end

    @current_user.save
  end

  def model_to_registration_mapping
    { :nickname => 'nickname', :email => 'email' }
  end
end
