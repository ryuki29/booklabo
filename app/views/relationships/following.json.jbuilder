# frozen_string_literal: true

json.array! @following do |user|
  json.id user.id
  json.name user.name

  if user.image.attached?
    json.image image_tag(user.image, class: 'follower-image')
  else
    json.image image_tag('default-user-image.jpg', class: 'follower-image')
  end
end
