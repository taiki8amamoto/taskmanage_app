class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if current_user
        flash[:info] = t('notice.create_user')
        redirect_to admin_users_path
      else
        session[:user_id] = @user.id
        redirect_to user_path(@user.id)
        flash[:info] = t('notice.create_user')
        flash[:success] = t('notice.welcome') + "#{current_user.name}" + t('notice.san')
      end
    else
      flash[:danger] = t('notice.failure_sighup')
      render template: "admin/users/new"
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.role == "admin" || current_user.id == @user.id
      flash[:danger] = t('notice.not_show_user')
      redirect_to tasks_path
    end
    @users = @user.tasks.page(params[:page]).per(100)
  end

  def update
    @user = User.find(params[:id])
    unless current_user.role == "admin" || current_user.id == @user.id
      flash[:danger] = t('notice.not_update_user')
      redirect_to tasks_path
    end
    if @user.update(user_params)
      flash[:success] = "#{@user.name}" + t('notice.update_user')
      redirect_to admin_users_path
    else
      flash[:danger] = t('flash.user_update')
      render template: "admin/users/edit"
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
