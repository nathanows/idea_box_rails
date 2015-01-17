class CategoriesController < ApplicationController

  def create
    Category.create(category_params)
    redirect_to admin_path
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_path
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
