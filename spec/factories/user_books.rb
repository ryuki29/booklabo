# frozen_string_literal: true

FactoryBot.define do
  factory :user_book do
    status { 0 }
    association :book
    association :user
  end
end
