class Comment < ActiveRecord::Base
  belongs_to :article
  attr_accessible :content, :email, :subject
  validates :subject, presence: true
  validates :email, presence: true
  validates :article_id, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  after_commit :_flush_all_cache

  def cached_article
    Rails.cache.fetch(["article_comment", self.id]) do
      Article.cached_find(self.article_id)
    end
  end

  def self.cached_find(id)
    Rails.cache.fetch([self.name, id]) do
      find(id)
    end
  end

  def self.cached_all
    Rails.cache.fetch([self.name, 'all']) do
      all.to_a
    end
  end

  def _flush_all_cache
    Rails.cache.delete([self.class.name, 'all'])
  end

  def _flush_article_cache
    Rails.cache.delete(["article_comment", self.id])
  end

  def _flush_cache_find
    Rails.cache.delete([self.class.name, self.id])
  end
end
