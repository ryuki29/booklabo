class BooksController < ApplicationController
  def index
  end

  def search
    @books = []

    unless params[:keyword].present?
      render :search
    end
    
    Amazon::Ecs::debug = true

    res = Amazon::Ecs.item_search(
      params[:keyword], {
        search_index: 'Books',
        country: 'jp',
        responce_group: 'ItemAttributes, Images'
      }
    )

    if res.present?
      res.items.each do |item|
        book = Book.new(
          title: item_attributes.get('Title'),
          author: item_attributes.get('Author'),
          image_url: item.get('MediumImage/URL')
        )
        @books << book
      end
    end
  end
end
