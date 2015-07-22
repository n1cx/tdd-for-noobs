require 'spec_helper'

feature "Article Page", :type => :feature do

  context "Article Show" do 
    it 'should have display comment' do
        article = FactoryGirl.create(:article)
        comment = FactoryGirl.create(:comment, article_id: article.id)
        visit articles_path
        click_link 'Show'
        expect(page).to have_text(comment.subject)       
    end
  end
end