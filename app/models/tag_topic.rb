class TagTopic < ApplicationRecord
   validates :topic, presence: true, uniqueness: true

   has_many(
      :taggings,
      class_name: 'Tagging',
      foreign_key: :tag_topic_id,
      primary_key: :id
   )

   has_many(
      :short_urls,
      -> { distinct },
      through: :taggings,
      source: :short_url
   )

   def popular_links
      short_urls.joins(:visits).group(:short_url, :long_url).order("COUNT(visits.id) DESC").select(:long_url, :short_url, "COUNT(visits.id) AS num_visits").limit(5)
   end
end