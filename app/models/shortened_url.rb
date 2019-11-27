class ShortenedUrl < ApplicationRecord
   validates :long_url, :user_id, presence: true
   validates :short_url, uniqueness: true

   belongs_to(
      :submitter,
      class_name: 'User',
      foreign_key: :user_id,
      primary_key: :id
   )

   def self.random_code
      new_code = SecureRandom.urlsafe_base64 until new_code && !exists?(short_url: new_code)
      new_code
   end

   def self.generate_short_url!(user, long_url)
      create!(:user_id => user.id, :long_url => long_url, :short_url => ShortenedUrl.random_code)
   end
end