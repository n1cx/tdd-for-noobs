class Article < ActiveRecord::Base
  attr_accessible :text, :title

  validates :title, presence: true, length: { minimum: 5 }

  after_commit :_flush_all_cache

  def self.cached_all
    Rails.cache.fetch([self.name, 'all']) do
      all.to_a
    end
  end

  def _flush_all_cache
    Rails.cache.delete([self.class.name, 'all'])
  end
end
