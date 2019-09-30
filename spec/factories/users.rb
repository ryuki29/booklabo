# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'testuser' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'pass1234' }
    password_confirmation { 'pass1234' }
  end
end
