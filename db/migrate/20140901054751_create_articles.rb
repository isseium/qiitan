class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :uuid
      t.integer :user_id
      t.string :title
      t.integer :stock_count
      t.string :url
      t.string :posted_at

      t.timestamps
    end
  end
end
