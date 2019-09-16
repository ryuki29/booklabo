class ChangeColumnOfUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :description, :string
  end

  def down
    change_column :users, :description, :text
  end
end
