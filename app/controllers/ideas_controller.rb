class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_idea, only: [:show, :edit, :update, :destroy, :toggle_vote]

  def index
    @ideas = Idea.all

    if params[:tags].present?
      @ideas = @ideas.tagged_with(params[:tags].split('/'), wild: true)
    end

    # @ideas = @ideas.order(cached_votes_up: :desc)
    
    if params[:sort] == "oldest"
      @ideas = @ideas.order(created_at: :asc)
    elsif params[:sort] == "newest"
      @ideas = @ideas.order(created_at: :desc)
    end

    if params[:votes] == "up"
      @ideas = @ideas.order(cached_votes_up: :desc)
    elsif params[:votes] == "down"
      @ideas = @ideas.order(cached_votes_up: :asc)
    end
  end

  def new 
    @idea = Idea.new
  end

  def show
  end

  def edit
  end

  def toggle_vote
    if current_user.voted_up_on?(@idea)
      @idea.unliked_by current_user
      render json: { votes: @idea.votes_for.size, current_user_vote: current_user.voted_up_on?(@idea) }
    else
      @idea.liked_by current_user
      render json: { votes: @idea.votes_for.size, current_user_vote: current_user.voted_up_on?(@idea) }
    end
  end

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to ideas_path
    else
      render new_idea_path
    end
  end

  def update
    if @idea.update(idea_params)
      redirect_to idea_path(@idea), notice: 'Idea was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @idea.destroy
    redirect_to ideas_path, notice: 'Idea was successfully destroyed.'
  end

  private
    def idea_params
      params.require(:idea).permit(
        :user_id,
        :name,
        :description,
        :tag_list
      )
    end

    def get_idea
      @idea = Idea.find(params[:id])
    end
end
