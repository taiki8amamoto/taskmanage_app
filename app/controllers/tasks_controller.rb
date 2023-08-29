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
      flash.now[:danger] = "Taskの登録に失敗しました"
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
      redirect_to tasks_path, notice: "Taskを更新しました！"
    else
      flash.now[:danger] = "Taskの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_path, notice: "Taskを削除しました！"
    else
      flash.now[:danger] = "Taskの削除に失敗しました"
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
