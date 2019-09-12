class CreateSnsUids < ActiveRecord::Migration[5.2]
  def change
    create_table :sns_uids do |t|
      t.string     :provider, null: false
      t.string     :uid,      null: false
      t.references :user,     foreign_key: true
      t.timestamps
    end
  end
end
