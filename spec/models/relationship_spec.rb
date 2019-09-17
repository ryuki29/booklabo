require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it "has a valid factory" do
    relationship = FactoryBot.build(:relationship)
    expect(relationship).to be_valid
  end

  it "is invalid when a relationship between the same pair of users has already been created" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    FactoryBot.create(
      :relationship,
      follower: user1,
      followed: user2
    )
    relationship = FactoryBot.build(
      :relationship,
      follower: user1,
      followed: user2
    )
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("はすでに存在します")
    expect(relationship.errors[:followed_id]).to include("はすでに存在します")
  end
end
