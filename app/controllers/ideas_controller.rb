class IdeasController < ApplicationController
  include IdeasHelper

  def create
    @idea = Idea.create(idea_params)
    add_images(params[:idea][:images])
    redirect_to user_path(@idea.user)
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])
    @idea.update(idea_params)
    @idea.images.clear
    add_images(params[:idea][:images])
    redirect_to user_path(@idea.user)
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
    redirect_to user_path(@idea.user)
  end

  private

    def idea_params
      params.require(:idea).permit(:title, :description, :category_id, :user_id)
    end

end
