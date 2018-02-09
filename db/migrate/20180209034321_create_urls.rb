class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :original_url
      t.string :url
      t.bigint :views, default: 0

      t.timestamps
    end
    add_index :urls, :url, unique: true
  end
end
