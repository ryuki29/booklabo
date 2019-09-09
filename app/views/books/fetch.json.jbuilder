json.array! @books do |book|
  json.title book.title
  json.authors book.authors
  json.image_url book.image_url
end