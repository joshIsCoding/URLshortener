class CreateTagTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_topics do |t|
      t.string :topic, null: false
    end
    add_index(:tag_topics, :topic, unique: true)
  end
end
