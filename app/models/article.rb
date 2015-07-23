class Article < ActiveRecord::Base
  attr_accessible :text, :title

  validates :title, presence: true, length: { minimum: 5 }

  after_commit :_flush_all_cache
  has_many :comments

  def cached_comments
    Rails.cache.fetch([self.class.name, "comments", self.id]) do
      self.comments.to_a
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

  def _flush_comment_cache
    Rails.cache.delete([self.class.name, "comments", self.id])
  end
end
