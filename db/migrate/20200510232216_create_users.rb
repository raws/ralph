class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.date :born_on
      t.string :email, null: false
      t.string :name, null: false
      t.date :started_on, comment: 'This person\'s first day at LevelUp'
      t.integer :zulip_id, null: false, index: true
    end
  end
end
