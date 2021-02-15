class RenameImageColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :image, :auth_image
  end
end
