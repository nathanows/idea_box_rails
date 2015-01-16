class IdeasController < ApplicationController

  def create
    @idea = Idea.create(idea_params)
    redirect_to user_path(@idea.user)
  end

  private

    def idea_params
      params.require(:idea).permit(:title, :description, :category_id, :user_id)
    end

end
