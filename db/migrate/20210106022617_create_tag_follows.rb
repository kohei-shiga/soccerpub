class CreateTagFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :tag_id], unique: true
    end
  end
end
