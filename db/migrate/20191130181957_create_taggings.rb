class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.integer :tag_topic_id, null: false
      t.integer :shortened_url_id, null: false
    end
  end
end
