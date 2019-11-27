class User < ApplicationRecord
   validates :email, presence: true, uniqueness: true

   has_many(
      :shortened_urls,
      class_name: 'ShortenedUrl',
      foreign_key: :user_id,
      primary_key: :id
   )
end