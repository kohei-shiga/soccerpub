class AddArticleIdToActionTextOembed < ActiveRecord::Migration[6.0]
  def change
    add_reference :action_text_oembeds, :article, foreign_key: true
  end
end
