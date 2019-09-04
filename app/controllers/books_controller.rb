class BooksController < ApplicationController
  def index
  end

  def search
    require 'net/http'
    require 'uri'
    require 'json'

    @books = []

    unless params[:keyword].present?
      render :search
      return
    end

    encoded_uri = URI.encode(
      "https://www.googleapis.com/books/v1/volumes?maxResults=20&q=#{params[:keyword]}&fields=items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    result = JSON.parse(Net::HTTP.get(parsed_uri))
    
    result["items"].each do |item|
      title = item["volumeInfo"]["title"] ||= ""
      authors = item["volumeInfo"]["authors"] ||= []
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
