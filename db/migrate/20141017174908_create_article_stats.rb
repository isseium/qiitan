class CreateArticleStats < ActiveRecord::Migration
  def change
    create_table :article_stats do |t|
      t.integer :article_id
      t.integer :stock_count
      t.date    :date

      t.timestamps
    end
    
    add_index :article_stats, [:article_id, :date]
  end
end
