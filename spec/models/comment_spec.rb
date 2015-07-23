require 'spec_helper'

describe Comment do
  context 'Validate' do
    it 'Should pass create comment and check valid factory' do
      FactoryGirl.create(:comment)
      expect(Comment.count).to eq(1)
    end

    it 'Subject should required field' do
      expect(FactoryGirl.build(:comment, subject: '')).to_not be_valid
    end

    it 'Email should required field and right format' do
      expect(FactoryGirl.build(:comment, email: '')).to_not be_valid
    end

    it 'Article id should required field' do
      expect(FactoryGirl.build(:comment, article_id: '')).to_not be_valid
    end
  end
  
  context 'Cache' do 
    before(:each) do
      Rails.cache.clear # empty cache between each tests
    end

    it 'should cache with correct key' do
      Rails.cache.stub(:fetch)
      Rails.cache.should_receive(:fetch).with(['Comment', 'all']).once
      Comment.cached_all
    end

    it 'should have all cache comment' do
      FactoryGirl.create(:comment)
 
      all = Comment.cached_all
      all.should be_kind_of(Array)
      expect(all.count).to eq(1)  
    end

    it 'should invalidate cached_all on create' do
      expect(Comment.cached_all.count).to eq(0)

      FactoryGirl.create(:comment)

      expect(Comment.cached_all.count).to eq(1)
    end

    it 'should invalidate cached_all on destroy' do
      comment = FactoryGirl.create(:comment)

      expect(Comment.cached_all.count).to eq(1)

      comment.destroy

      expect(Comment.cached_all.count).to eq(0)
    end

    it 'should invalidate cached_all on update' do
      comment = FactoryGirl.create(:comment)

      Comment.cached_all

      comment.email = 'phendy@readflyer.com'
      comment.save!

      expect(Comment.cached_all).to eq([comment])
    end

    it 'should have cached_find by comment_id' do
      comment = FactoryGirl.create(:comment)

      expect(Comment.cached_find(comment.id).id).to eq(comment.id)       
    end

    it 'should invalidate cached_find on update' do
      comment = FactoryGirl.create(:comment)

      expect(Comment.cached_find(comment.id)).to eq(comment)

      comment.email = 'phendy@readflyer.com'
      comment.save!

      expect(Comment.cached_find(comment.id)).to eq(comment)       
    end

    it 'should have cached_article by comment_id' do
      article = FactoryGirl.create(:article)
      comment = FactoryGirl.create(:comment, article_id: article.id)

      expect(comment.cached_article.id).to eq(article.id)       
    end

    it 'should invalidate cached_article on '
  end
end
