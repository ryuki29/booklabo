class Book < ApplicationRecord
  attr_accessor :title, :author, :image_url

  def initialize(title, author, image_url)
    @title = title
    @image_url = image_url
    
  end
end
