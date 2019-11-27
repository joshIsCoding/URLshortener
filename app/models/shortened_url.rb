class ShortenedUrl < ApplicationRecord
   validates :long_url, :user_id, presence: true
   validates :short_url, uniqueness: true

   belongs_to(
      :user,
      class_name: 'User',
      foreign_key: :user_id,
      primary_key: :id
   )
end