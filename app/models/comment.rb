class Comment < ActiveRecord::Base
  belongs_to :article
  attr_accessible :content, :email, :subject
  validates :subject, presence: true
  validates :email, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def self.cached_article(id)
    Rails.cache.fetch(["#{self.name}_article", id]) do
      find(id).article
    end
  end

  def self.cached_find(id)
    Rails.cache.fetch([self.name, id]) do
      find(id)
    end
  end

  def self.cached_all(article_id)
    Rails.cache.fetch([self.name, 'all_#{article_id}']) do
      result = all.select{|comment| comment.article_id = article_id}
      result.to_a
    end
  end

  def _flush_all_cache
    Rails.cache.delete([self.class.name, 'all'])
  end
end
