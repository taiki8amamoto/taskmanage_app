class TasksController < ApplicationController
  before_action :basic

  def index
    case params[:sort_expired]
    when "desc"
      @tasks = Task.all.order("deadline DESC")
    when "asc"
      @tasks = Task.all.order("deadline ASC")
    else
      @tasks = Task.all.order("created_at DESC")
    end
  end

  def sort_deadline
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('notice.create')
    else
      flash.now[:danger] = t('flash.create')
      render :new
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('notice.update')
    else
      flash.now[:danger] = t('flash.update')
      render :edit
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_path, notice: t('notice.destroy')
    else
      flash.now[:danger] = t('flash.destroy')
      render :index
    end
  end
  
  private
  
  def basic
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline)
  end
end
