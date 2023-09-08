class TasksController < ApplicationController

  def index
    case params[:sort_deadline]
    when "desc"
      @tasks = current_user.tasks.all.order("deadline DESC")
    when "asc"
      @tasks = current_user.tasks.all.order("deadline ASC")
    else
      @tasks = current_user.tasks.all.order("created_at DESC")
    end
    case params[:sort_priority]
    when "desc"
      @tasks = current_user.tasks.all.order("priority DESC")
    when "asc"
      @tasks = current_user.tasks.all.order("priority ASC")
    end
    if params[:search].present?
      if params[:search][:title].present? && params[:search][:progress].present?
        @tasks = @tasks.search_by_title_and_progress(params[:search][:title], params[:search][:progress])
      elsif params[:search][:title].present?
        @tasks = @tasks.search_by_title(params[:search][:title])
      elsif params[:search][:progress].present?
        @tasks = @tasks.search_by_progress(params[:search][:progress])
      end
      if @tasks.empty?
        flash.now[:info] = t('..info_0') 
      else
        flash.now[:info] = "#{@tasks.count}" + t('notice.info')
      end
    end
    @tasks = @tasks.page(params[:page]).per(100)
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path
      flash[:success] = t('notice.task_create')
    else
      flash.now[:danger] = t('flash.create')
      render :new
    end
  end
  
  def show
    @task = Task.find(params[:id])
    unless current_user.id == @task.user.id
      flash[:danger] = t('notice.not_show_tasks')
      redirect_to tasks_path
    end
  end
  
  def edit
    @task = Task.find(params[:id])
    unless current_user.id == @task.user.id
      flash[:danger] = t('notice.not_edit_tasks')
      redirect_to tasks_path
    end
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path
      flash[:success] = t('notice.update')
    else
      flash.now[:danger] = t('flash.update')
      render :edit
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    if current_user.id == @task.user.id
      @task.destroy
      redirect_to tasks_path
      flash[:success] = t('notice.destroy')
    else
      flash.now[:danger] = t('notice.not_destroy_tasks')
      render :index
    end
  end
  
  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :progress, :priority)
  end
end
