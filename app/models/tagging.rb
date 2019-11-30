class Tagging < ApplicationRecord
   validates :tag_topic_id, :shortened_url_id, presence: true
end