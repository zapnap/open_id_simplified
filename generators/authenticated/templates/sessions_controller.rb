class SessionsController < ApplicationController
  def create
    @open_id_url = params[:openid_identifier]
    if request.post? || using_open_id?
      authenticate_with_open_id(@open_id_url,
          :optional => [:nickname, :email]) do |result, identity_url, registration|
        if !result.successful?
          flash.now[:error] = result.message
          render(:action => 'new')
        elsif !(identity_url = IdentityUrl.find_or_create_by_url(identity_url))
          flash.now[:error] = "No user with OpenID URL #{identity_url}"
          render(:action => 'new')
        else
          if identity_url.user.nil?
            flash.now[:notice] = "Thanks for signing up!"
            identity_url.create_user && identity_url.save
          end

          self.current_user = identity_url.user
          assign_registration_attributes!(registration)
          redirect_to(root_path)
        end
      end
    end
  end

  def destroy
    self.current_user = nil
    redirect_to(root_path)
  end

private

  # registration is a hash containing the valid sreg keys
  # use this to assign returned values to user model attributes
  def assign_registration_attributes!(registration)
    model_to_registration_mapping.each do |model_attribute, registration_attribute|
      unless registration[registration_attribute].blank?
        @current_user.send("#{model_attribute}=", registration[registration_attribute])
      end
    end
    @current_user.save
  end

  # maps sreg keys/attributes to user model attributes
  def model_to_registration_mapping
    { :nickname => 'nickname', :email => 'email' }
  end
end
