class CreateReportSpams < ActiveRecord::Migration[6.0]
  def change
    create_table :report_spams do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :article_id], unique: true
    end
  end
end
