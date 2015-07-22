require 'spec_helper'

describe Comment do
  context "Validate" do
    it 'should have a valid factory' do
      FactoryGirl.create(:comment)
    end

    it "Comment must belongs to article" do
      comment = FactoryGirl.create(:comment)

      expect(comment.respond_to?(:article)).to be true
    end

    it "Should pass create comment" do
      expect do
        comment = FactoryGirl.create(:comment)
      end.to change{Comment.count}.by(1)
    end

    it "Subject should required field" do
      expect(FactoryGirl.build(:comment, subject: "")).to_not be_valid
    end

    it "Email should required field and right format" do
      expect(FactoryGirl.build(:comment, email: "")).to_not be_valid
    end
  end
  
  context "Cached" do 
    before(:each) do
      Rails.cache.clear # empty cache between each tests
    end

    it "should have cached_all by article" do
      article = FactoryGirl.create(:article)
      comment = FactoryGirl.create(:comment, article_id: article.id)

      expect(Comment.cached_all(article.id).count).to eq(1)  
    end

    it "should have cached_find by comment_id" do
      comment = FactoryGirl.create(:comment)

      expect(Comment.cached_find(comment.id).id).to eq(comment.id)       
    end

    it "should have cached_article by comment_id" do
      article = FactoryGirl.create(:article)
      comment = FactoryGirl.create(:comment, article_id: article.id)

      expect(Comment.cached_article(comment.id).id).to eq(article.id)       
    end
  end
end
