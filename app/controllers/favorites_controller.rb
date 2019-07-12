class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    favorite = current_user.favorites.build(micropost_id: params[:micropost_id])
    favorite.save
    redirect_to root_url
  end

  def destroy
    favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
    favorite.destroy
    redirect_to root_url
  end
end
