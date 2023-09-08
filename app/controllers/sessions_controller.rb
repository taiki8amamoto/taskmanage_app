class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = t('notice.welcome_back') + "#{current_user.name}" + t('notice.san')
      redirect_to user_path(user.id)
    else
    flash.now[:danger] = t('notice.failure_login')
    render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = t('notice.success_logout')
    redirect_to new_session_path
  end
end
