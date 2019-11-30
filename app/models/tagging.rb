class Tagging < ApplicationRecord
   validates :tag_topic_id, :shortened_url_id, presence: true
   
   belongs_to(
      :short_url,
      class_name: 'ShortenedUrl',
      foreign_key: :shortened_url_id,
      primary_key: :id
   )

   belongs_to(
      :tagged_topic,
      class_name: 'TagTopic',
      foreign_key: :tag_topic_id,
      primary_key: :id
   )
end