class TagTopic < ApplicationRecord
   validates :topic, presence: true, uniqueness: true
end