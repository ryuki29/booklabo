json.array! @following do |user|
  json.id user.id
  json.name user.name
  
  if user.image.attached?
    json.image url_for(user.image)
  else
    json.image url_for("/assets/default-user-image.jpg")
  end
end
