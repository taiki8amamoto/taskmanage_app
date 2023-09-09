class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
      flash[:info] = t('notice.create_user')
      flash[:success] = t('notice.welcome') + "#{current_user.name}" + t('notice.san')
    else
      flash[:danger] = t('notice.failure_sighup')
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      flash[:danger] = t('notice.not_show')
      redirect_to tasks_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
