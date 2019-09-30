# frozen_string_literal: true

json.array! @books do |book|
  json.title book.title
  json.authors book.authors
  json.image_url book.image_url
  json.id book.id
  json.uid book.uid
end
