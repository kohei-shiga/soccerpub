class CreateActionTextOembeds < ActiveRecord::Migration[6.0]
  def change
    create_table :action_text_oembeds do |t|
      t.string :url
      t.json :raw_info

      t.timestamps
    end
  end
end
