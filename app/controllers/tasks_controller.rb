class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Taskを登録しました！"
    else
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
    if @task.update
      redirect_to tasks_path, notice: "Taskを更新しました！"
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(tasks).permit(:title, :content)
  end
end
