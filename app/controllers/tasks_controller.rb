class TasksController < ApplicationController

  def index
    @tasks = current_user.tasks.all.includes(:user).order("created_at DESC")
    case params[:sort_deadline]
    when "desc"
      @tasks = current_user.tasks.all.includes(:user).order("deadline DESC")
    when "asc"
      @tasks = current_user.tasks.all.includes(:user).order("deadline ASC")
    end
    case params[:sort_priority]
    when "desc"
      @tasks = current_user.tasks.all.includes(:user).order("priority DESC")
    when "asc"
      @tasks = current_user.tasks.all.includes(:user).order("priority ASC")
    end
    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.search_by_title(params[:search][:title])
      end
      if params[:search][:progress].present?
        @tasks = @tasks.search_by_progress(params[:search][:progress])
      end
      if params[:search][:label].present?
        label = params[:search][:label]
        task_id = Tag.where(label_id: label).pluck(:task_id)
        @tasks = @tasks.where(id: task_id)
      end
      flash.now[:info] = "#{@tasks.count}" + t('notice.info')
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
    params.require(:task).permit(:title, :content, :deadline, :progress, :priority, label_ids: [])
  end
end
