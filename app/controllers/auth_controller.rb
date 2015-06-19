class AuthController < ApplicationController
  before_filter :authenticate_user!
  def create
    auth = request.env["omniauth.auth"]
    uid = auth["uid"]
    provider = auth["provider"]
    token = auth["credentials"]["token"]
    secret = auth["credentials"]["secret"]

    @user = current_user
    unless @user.auths.find_by_uid_and_provider(uid,provider)
      @user.auths.create(uid:uid, provider:provider, token:token, secret:secret, user_id:current_user.id)
    end
    redirect_to setting_path
  end

  def destroy
    provider = params[:provider]
    @user = current_user
    auth = @user.auths.find_by_provider_and_user_id(provider,current_user.id)
    auth.destroy
    redirect_to setting_path
  end
end
