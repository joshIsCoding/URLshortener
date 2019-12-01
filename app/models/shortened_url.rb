class ShortenedUrl < ApplicationRecord
   validates :long_url, :user_id, presence: true
   validates :short_url, uniqueness: true
   validate :no_spamming, :nonpremium_max
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

   has_many(
      :taggings,
      class_name: 'Tagging',
      foreign_key: :shortened_url_id,
      primary_key: :id
   )

   has_many :visitors, 
      -> { distinct },
      through: :visits, 
      source: :visitor

   has_many :tagged_topics, 
      -> { distinct },
      through: :taggings, 
      source: :tagged_topic

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

   def self.prune(n)
      ShortenedUrl.joins(:submitter).left_outer_joins(:visits).where(
            "shortened_urls.id NOT IN (
            SELECT
               shortened_urls.id
            FROM
               shortened_urls
            LEFT OUTER JOIN
               visits ON visits.shortened_url_id = shortened_urls.id
            WHERE 
               (visits.created_at >= \'#{n.minute.ago}\' 
                  OR shortened_urls.created_at >= \'#{n.minute.ago}\') 
                  OR users.premium = true)"
      ).destroy_all
   end

   private
   def no_spamming
      recently_created = ShortenedUrl.select(:id).where(["created_at >= ? AND user_id = ?", 1.minutes.ago, user_id]).count
      errors[:base] << "You can't create more than 5 links per minute" if recently_created >= 5
   end

   def nonpremium_max
      unless submitter.premium
         total_created = ShortenedUrl.where(["user_id = ?", user_id]).length
         errors[:maximum] << "number of new links for non-premium users is 5" if total_created >= 5
      end
   end

end