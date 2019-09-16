json.array! @followers do |user|
  json.id user.id
  json.name user.name

  if user.image.attached?
    json.image url_for(user.image)
  end
end
