require 'spec_helper'

describe ArticlesController do
  describe 'GET #index' do
    it 'renders the index view' do
      get :index
      response.should render_template :index
    end

    it 'populates an array of articles' do
      article = FactoryGirl.create(:article)
      get :index

      assigns(:articles).should eq [article]
    end
  end
end
