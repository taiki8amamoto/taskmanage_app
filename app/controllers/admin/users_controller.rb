class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    case params[:sort_role]
    when "desc"
      @users = User.all.order("role DESC")
    when "asc"
      @users = User.all.order("role ASC")
    else
      @users = User.all
    end
    @users = @users.page(params[:page]).per(10)
    unless current_user.role == "admin"
      flash[:danger] = t('notice.not_show_user_index')
      redirect_to tasks_path
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.role == "admin"
      flash[:danger] = t('notice.not_show_user')
      redirect_to tasks_path
    end
    @users = @user.tasks.page(params[:page]).per(100)
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.role == "admin"
      flash[:danger] = t('notice.not_edit_user')
      redirect_to tasks_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "#{@user.name}" + t('notice.destroy_user')
      redirect_to admin_users_path
    else
      flash[:danger] = t('flash.user_destroy')
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
