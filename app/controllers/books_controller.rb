class BooksController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  
  def index
  end

  def search
    @books = []

    if params[:keyword].empty?
      render :search
      return
    end

    encoded_uri = URI.encode(
      "https://www.googleapis.com/books/v1/volumes?q=#{params[:keyword]}
       &fields=items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    result = JSON.parse(Net::HTTP.get(parsed_uri))
    
    result["items"].each do |item|
      title = item["volumeInfo"]["title"] ?
        item["volumeInfo"]["title"] :
        ""
      authors = item["volumeInfo"]["authors"] ?
        item["volumeInfo"]["authors"] :
        ""
      image_url = item["volumeInfo"]["imageLinks"] ? 
        item["volumeInfo"]["imageLinks"]["thumbnail"] : 
        ""

      book = {
        title: title,
        authors: authors,
        image_url: image_url
      }
      @books << book
    end
  end
end
