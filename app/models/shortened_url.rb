class ShortenedUrl < ApplicationRecord
   validates :long_url, :user_id, presence: true
   validates :short_url, uniqueness: true

   belongs_to(
      :submitter,
      class_name: 'User',
      foreign_key: :user_id,
      primary_key: :id
   )

   has_many(
      :visits,
      class_name: 'Visit',
      foreign_key: :shortened_url_id,
      primary_key: :id
   )

   has_many :visitors, 
      -> { distinct },
      through: :visits, 
      source: :visitor

   def self.random_code
      new_code = SecureRandom.urlsafe_base64 until new_code && !self.exists?(short_url: new_code)
      new_code
   end

   def self.generate_short_url!(user, long_url)
      create!(:user_id => user.id, :long_url => long_url, :short_url => ShortenedUrl.random_code)
   end

   def num_clicks
      visits.count
   end

   def num_uniques
      visitors.count
   end

   def num_recent_uniques
      visits.select(:visitor_id).where(["created_at > ?", 10.minutes.ago]).distinct.count
   end

end