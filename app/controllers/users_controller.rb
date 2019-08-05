class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :favorite_micropost, :likes, :edit, :update,
  :destroy]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def destroy 
    @user = User.find_by(id: params[:id])
    @micropost = Micropost.find_by(user_id: params[:id])
    flash[:notice] = "ユーザーを削除しました！"

    if @microposts.nil?
      @user.destroy
      redirect_to("/")
    else
      @micropost.destroy
      @user.destroy
      redirect_to("/")
    end 
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'ユーザ情報を変更しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザ情報の更新に失敗しました。'
      render :edit
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.favorites.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end
end