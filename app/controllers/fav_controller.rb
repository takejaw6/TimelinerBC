class FavController < ApplicationController
  before_filter :authenticate_user!
  def create
    @user = current_user
    @fav = current_user.favs.new(addfav_params)
    @fav.save

    redirect_to feed_path
  end

  def index
    @user = current_user
    @unsorted = current_user.favs.all
    @favs = @unsorted.order(:datetime).reverse
  end

  def destroy
    unique_id = params[:unique_id]
    provider = params[:provider]
    @user = current_user
    @fav = @user.favs.find_by_unique_id(unique_id)
    if @fav.provider == provider
      @fav.destroy
    end
    redirect_to :back
  end

  private

  def addfav_params
    params.require(:fav).permit(:unique_id, :content, :contentimg, :bywhomimg, :datetime, :provider, :bywhom, :user_id)
  end
end
