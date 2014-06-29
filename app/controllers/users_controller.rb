class UsersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end  

  def index
    @users = User.paginate(page: params[:page]) 
  end

  def new
    @user = User.new
  
   def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Добро пожаловать! "
      redirect_to @user
    else
      render 'new'
    end
   end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь уничтожен."
    redirect_to users_url
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Профиль обновлен"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end  
  end

  def following
    @title = "Читаемые"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Читатели"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Пожалуйста зайдите в систему."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

