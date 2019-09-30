# frozen_string_literal: true

FactoryBot.define do
  factory :sns_uid do
    provider { 'twitter' }
    uid { 123_456_789_012_345_678 }
    association :user
  end
end
