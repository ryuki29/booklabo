require_relative 'application'

Rails.application.initialize!

Amazon::Ecs.options = {
  associate_tag:     Rails.application.credentials.amazon_api[:associate_tag],
  AWS_access_key_id: Rails.application.credentials.amazon_api[:access_key],
  AWS_secret_key:    Rails.application.credentials.amazon_api[:secret_key]
}
