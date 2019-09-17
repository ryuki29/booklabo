require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "is valid with a name with 20 characters" do
    user = FactoryBot.build(:user, name: "アイウエオカキクケコサシスセソタチツテト")
    expect(user).to be_valid
  end

  it "is invalid with a name with 20 characters" do
    user = FactoryBot.build(:user, name: "アイウエオカキクケコサシスセソタチツテトナ")
    user.valid?
    expect(user.errors[:name]).to include("は20文字以内で入力してください")
  end

  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "test@example.com")
    user = FactoryBot.build(:user, email: "test@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "is invalid with an email address with an invalid format" do
    user = FactoryBot.build(:user, email: "invalidemail")
    user.valid?
    expect(user.errors[:email]).to include("のフォーマットが不適切です")
  end

  it "is invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "is invalid with a password with 6 characters" do
    user = FactoryBot.build(
      :user,
      password: "pass12",
      password_confirmation: "pass12"
    )
    user.valid?
    expect(user.errors[:password]).to include("は7文字以上で入力してください")
  end

  it "is valid with a password with 7 characters" do
    user = FactoryBot.build(
      :user,
      password: "pass123",
      password_confirmation: "pass123"
    )
    expect(user).to be_valid
  end

  it "is valid with a password with 128 characters" do
    user = FactoryBot.build(
      :user,
      password: "QMuAktZciJ3fwL633AnHYZfG5OxQdSURsehAy4CECtKY4GPW42tQQwnJbIpco8TGcY4yQw3iOB5I5KuXBLDh8QQ7n49B0Q62E0pklgrZFkvAUOnjpQqlv5gGXf5NV1Dn",
      password_confirmation: "QMuAktZciJ3fwL633AnHYZfG5OxQdSURsehAy4CECtKY4GPW42tQQwnJbIpco8TGcY4yQw3iOB5I5KuXBLDh8QQ7n49B0Q62E0pklgrZFkvAUOnjpQqlv5gGXf5NV1Dn"
    )
    expect(user).to be_valid
  end

  it "is invalid with a password with 129 characters" do
    user = FactoryBot.build(
      :user,
      password: "QMuAktZciJ3fwL633AnHYZfG5OxQdSURsehAy4CECtKY4GPW42tQQwnJbIpco8TGcY4yQw3iOB5I5KuXBLDh8QQ7n49B0Q62E0pklgrZFkvAUOnjpQqlv5gGXf5NV1DnA",
      password_confirmation: "QMuAktZciJ3fwL633AnHYZfG5OxQdSURsehAy4CECtKY4GPW42tQQwnJbIpco8TGcY4yQw3iOB5I5KuXBLDh8QQ7n49B0Q62E0pklgrZFkvAUOnjpQqlv5gGXf5NV1DnA"
    )
    user.valid?
    expect(user.errors[:password]).to include("は128文字以内で入力してください")
  end

  it "is invalid with a password only with alphabets" do
    user = FactoryBot.build(
      :user,
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:password]).to include("には英字と数字の両方を含めてください")
  end

  it "is invalid with a password only with numbers" do
    user = FactoryBot.build(
      :user,
      password: "12345678",
      password_confirmation: "12345678"
    )
    user.valid?
    expect(user.errors[:password]).to include("には英字と数字の両方を含めてください")
  end

  it "is invalid without a password confirmation" do
    user = FactoryBot.build(
      :user,
      password_confirmation: nil
    )
    user.valid?
    expect(user.errors[:password_confirmation]).to include("を入力してください")
  end

  it "is valid with a url with 101 characters" do
    user = FactoryBot.build(
      :user,
      url: "https://Ag1AYg3TPs7Qy7z5sSftsilC7AUwmWQK1F8PMZwpiu6EptxH9A1pIaPGyy0KkHi9agOM6b0ctUEId1dap2qX23rqri0A"
    )
    expect(user).to be_valid
  end

  it "is invalid with a url with 101 characters" do
    user = FactoryBot.build(
      :user,
      url: "https://Ag1AYg3TPs7Qy7z5sSftsilC7AUwmWQK1F8PMZwpiu6EptxH9A1pIaPGyy0KkHi9agOM6b0ctUEId1dap2qX23rqri0AN"
    )
    user.valid?
    expect(user.errors[:url]).to include("は100文字以内で入力してください")
  end

  it "is invalid with a url in an invalid format" do
    user = FactoryBot.build(
      :user,
      url: "http:/invalid.com"
    )
  end

  it "is valid with a desription with 160 characters" do
    user = FactoryBot.build(
      :user,
      description: "ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろ"
    )
    expect(user).to be_valid
  end

  it "is invalid with a discription with 161 characters" do
    user = FactoryBot.build(
      :user,
      description: "ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎ"
    )
    user.valid?
    expect(user.errors[:description]).to include("は160文字以内で入力してください")
  end
end
