module IdeasHelper
  def add_images(images)
    images.map do |image_id|
      Image.find_by(:id => image_id)
    end.compact.each do |image|
      @idea.images << image
    end
  end
end
