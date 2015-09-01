class ProjectsController < ApplicationController
  before_filter :authenticate_user!, except: [:work, :products]
  before_filter :get_project, only: [:show, :edit, :update, :destroy, :work_show, :products_show]

  def index
    @projects = Project.all
  end

  def work
    @projects = Project.with_category(:contract).where(is_public: true)
    render layout: 'landing'
  end

  def work_show
    render layout: 'landing', template: 'projects/work_show'
  end

  def products
    @projects = Project.with_category(:product).where(is_public: true)
    render layout: 'landing'
  end

  def products_show
    render layout: 'landing', template: 'projects/products_show'
  end

  def new 
    @project = Project.new
  end

  def show
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to projects_path
    else
      render new_project_path
    end
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  private
    def project_params
      params.require(:project).permit(
        :name,
        :description,
        :category,
        :status,
        :image
      )
    end

    def get_project
      @project = Project.find(params[:id])
    end
end