class BooksController < ApplicationController
  def index
  end

  def search
    require 'net/http'
    require 'uri'
    require 'json'

    @books = []
    @keyword = params[:keyword]
    @total_items = 0
    @page = params[:page]

    return if params[:keyword].empty?

    encoded_uri = URI.encode(
      "https://www.googleapis.com/books/v1/volumes?maxResults=20&startIndex=#{params[:page]}&q=#{params[:keyword]}&fields=totalItems,items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    result = JSON.parse(Net::HTTP.get(parsed_uri))

    @total_items = result["totalItems"]
    return if @total_items == 0
    @total_items = 100 if @total_items > 0
    
    result["items"].each do |item|
      uid = item["id"]
      title = item["volumeInfo"]["title"] ||= ""
      authors = item["volumeInfo"]["authors"] ||= []
      image_url = item["volumeInfo"]["imageLinks"] ? 
        item["volumeInfo"]["imageLinks"]["thumbnail"] : 
        "book-default.png"

      book = {
        uid: uid,
        title: title,
        authors: authors,
        image_url: image_url
      }
      @books << book
    end
  end
end
