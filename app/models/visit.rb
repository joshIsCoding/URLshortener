class Visit < ApplicationRecord
   validates :visitor_id, :shortened_url_id, presence: true

   belongs_to(
      :visitor,
      class_name: 'User',
      foreign_key: :visitor_id,
      primary_key: :id
   )

   belongs_to(
      :visited_url,
      class_name: 'ShortenedUrl',
      foreign_key: :shortened_url_id,
      primary_key: :id
   )

   def self.record_visit!(user, shortened_url)
      create!(:visitor_id => user.id, :shortened_url_id => shortened_url.id)
   end
end