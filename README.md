#TDD for noobs
##Introduction
By the end of this tutorial you will have a taste of:

* test-driven development using RSpec and guard
* Rails cache interface
* Slim view template engine

Recommended readings:

* [Test-driven development on Wikipedia](https://en.wikipedia.org/wiki/Test-driven_development)
* [Model Caching (RailsCasts)](http://railscasts.com/episodes/115-model-caching-revised)
* [Testing Controllers with Rspec](http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html)
* [Testing Routes using Rspec](http://ilovefoobar.wordpress.com/2014/02/23/testing-routes-using-rspec/)
* [Test your Rake tasks! (Pivotal Labs)](http://pivotallabs.com/how-i-test-rake-tasks/)

###What is TDD?
Test-driven development (TDD) is a software development process that relies on the repetition of a very short development cycle: first the developer writes an (initially failing) automated test case that defines a desired improvement or new function, then produces the minimum amount of code to pass that test, and finally refactors the new code to acceptable standards.
###Why TDD?
TODO

##Getting Started
This guide is based on [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html).

###Configuration Set up
####Add your gems
In ```Gemfile```,

	gem 'mysql2' 			# database adapter
	gem 'dalli'				# memcached client
	
	group :development do
  		gem 'debugger'
  		gem 'guard' 		# runs tests automatically
  		gem 'foreman' 		# manage app dependencies (redis, memcached, etc.)
  		gem 'thin'			# faster web server
  		gem 'faker'			# random values
	end
	
	group :test do
		gem 'guard-rspec'
		gem 'test_after_commit' # to fire after_commit AR hooks on spec
	end
	
	group :development, :test do
		gem 'rspec-rails'
		gem 'rspec-mocks'
	 	gem 'factory_girl_rails'
	end


Run ```bundle install``` after adding your gems.

####Configure memcached
From [github/dalli](https://github.com/mperham/dalli)

In ```config/environments/development.rb```

	config.cache_store = :dalli_store, 'localhost', { namespace: "tdd", compress: true}


	

####Configure mysql2 adapter
In ```config/database.yml```

	development:
		adapter: mysql2
		encoding: utf8
		reconnect: false
		database: tdd-development
		pool: 5
		username: root
		password: 
		host: localhost
  		
####Configure foreman
In ```Procfile```

	c: memcached
	
####Configure rspec
In terminal, ```rails g rspec:install```

####Configure guard
In ```Guardfile```

	# A sample Guardfile
	# More info at https://github.com/guard/guard#readme
	
	guard :rspec do
	  watch(%r{^spec/.+_spec\.rb$})
	  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
	  watch('spec/spec_helper.rb')  { "spec" }
	 
	  # Rails example
	  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
	  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
	  #watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
	  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
	  watch('config/routes.rb')                           { "spec/routing" }
	  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
	  watch(%r{^app/models/(.+)\.rb$}) {|m| "spec/models/#{m[1]}_spec.rb" }
	  watch(%r{^app/models/demand_partners/(.+)\.rb$}) {|m| "spec/models/demand_partners/#{m[1]}_spec.rb" }
	  watch(%r{^app/models/concerns/(.+)\.rb$}) {|m| "spec/models/concerns/#{m[1]}_spec.rb" }
	 
	  # Capybara features specs
	  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }
	 
	  # Turnip features and steps
	  watch(%r{^spec/acceptance/(.+)\.feature$})
	  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
	end
The ```Guardfile``` specifies which directories/files ```guard``` will track for changes.

###Hello Rails
####Create a database
In terminal, ```rake db:create```

####Start the server
In terminal, ```rails s```

Open your browser to ```http://localhost:3000```

Now that configuration is complete we can begin development.

####The app
For starters, we will be creating a blog app that can:

* post articles
  * with a title, that is a required field, and has a minimum of 5 characters
  * and a text content


#####Creating articles
In terminal, ```rails g model Article title:string text:text```, which will output:
	
	invoke  active_record
	create    db/migrate/20140707082800_create_articles.rb
	create    app/models/article.rb
	invoke    rspec
	create      spec/models/article_spec.rb
	invoke      factory_girl
    create        spec/factories/articles.rb

Then, ```rake db:migrate``` to update the changes to the database.

#####Testing articles
In terminal, start ```guard```.

In ```spec/models/article_spec.rb```, we will write our first test. First, we will need to test for a valid factory, as such:

	  it 'should have a valid factory' do
	    FactoryGirl.create(:article)
	  end

Initially, we will get an error, ```Mysql2::Error: Table 'tdd-test.articles' doesn't exist: SHOW FULL FIELDS FROM `articles` ``` because the test database has not been updated. So, in terminal, ```rake db:test:prepare```.

Now when we run the test again, it should all be passing.

######Testing validation
Now, we want to make sure that every article has a title. We begin by creating a test to validate the title.

	it 'should not be valid without a title' do
      FactoryGirl.build(:article, title: '').should_not be_valid
  	end

The test fails, as such:

	1) Article should not be valid without a title
     Failure/Error: FactoryGirl.build(:article, title: '').should_not be_valid
       expected #<Article id: nil, title: "", text: "Quasi voluptas aut beatae aut qui architecto. Et eu...", created_at: nil, updated_at: nil> not to be valid

So we begin by writing code to pass that test. In ```app/models/article.rb```,

	validates :title, presence: true

Where now, both tests are passing:

	2 examples, 0 failures
	
Next, we want to make sure that the title has a minimum of 5 characters:

    it 'should not be valid with a title that has less than 5 characters' do
      FactoryGirl.build(:article, title: '1234').should_not be_valid
    end
    
Which again fails, so we can start writing the code:

	validates :title, presence: true, length: { minimum: 5 }

Now, the tests should pass.

######Testing methods
######Caching
Let's say that we now want to have a method that caches all of the articles. We will call this method ```cached_all```.

In ```spec/models/article_spec.rb```, we want to verify that we are calling the cache by:

    it 'should receive cache' do
      Rails.cache.stub(:fetch)
      Rails.cache.should_receive(:fetch).with(['Article', 'all']).once
      Article.cached_all
    end
    
To pass,

	  def self.cached_all
	    Rails.cache.fetch([self.name, 'all']) do
	    end
	  end

Next, we add another test to verify the value of the cache.

	it 'should cache all' do
		FactoryGirl.create(:article)
		
		all = Article.cached_all
		all.should be_kind_of(Array)
		all.count.should eq 1
	end
	
With code,

	def self.cached_all
    	Rails.cache.fetch([self.name, 'all']) do
      		all.to_a
    	end
  	end

With caches, we need to invalidate the cache otherwise we will end up with stale data. To verify:
    
    it 'should invalidate cached_all on create' do
      Article.cached_all.count.should eq 0 # warm cache
      
      article = FactoryGirl.create(:article)

      Article.cached_all.count.should eq 1
    end

With code:

	after_create :_flush_all_cache
	
It should also invalidate on destroy:

    it 'should invalidate cached_all on destroy' do
      article = FactoryGirl.create(:article)

      Article.cached_all.count.should eq 1 # warm cache
      
      article.destroy

      Article.cached_all.count.should eq 0
    end
    
To pass:

	after_destroy :_flush_all_cache
	
Lastly, it should invalidate on update:

    it 'should invalidate cached_all on update' do
      article = FactoryGirl.create(:article)

      Article.cached_all # warm cache

      article.text = 'abc'
      article.save!

      Article.cached_all.should eq [article]
    end
    
To pass:

	after_update :_flush_all_cache
	
However, in Rails, ```after_create```, ```after_update```, and ```after_destroy```, can be represented as ```after_commit```. So in ```app/models/article.rb```, we change those 3 lines into:

	after_commit :_flush_all_cache
	
We can verify that they are the same by running the tests again, and it should still be passing all the prior tests.

Next we will want to create the web interface for articles, using routes, controllers, and views.

#####Routes
Since we want to be able to CRUD the articles, we will use ```resources```. So in ```routes.rb```,

	resources :articles
	
Using ```rake routes``` in terminal,

	articles     GET    /articles(.:format)          articles#index
	             POST   /articles(.:format)          articles#create
	 new_article GET    /articles/new(.:format)      articles#new
	edit_article GET    /articles/:id/edit(.:format) articles#edit
	     article GET    /articles/:id(.:format)      articles#show
	             PUT    /articles/:id(.:format)      articles#update
	             DELETE /articles/:id(.:format)      articles#destroy
	             
We get a 'resourceful' route, but for this example we will only want to display a list of articles (index), so in ```spec/routing/articles_routing_spec.rb```:

	  it 'should route get index' do
	    expect(get: '/articles').to be_routable
	    expect(get: '/articles').to route_to(controller: 'articles', action: 'index')
	  end

#####Controller
Now that we have a model and routes for articles, we want to create a controller for articles. In terminal,

	rails g controller articles
	
In ```spec/controllers/articles_controller_spec.rb```,

	it 'renders the index view' do
      get :index
      response.should render_template :index
    end

We get a ```AbstractController::ActionNotFound``` error, so we create an ```index``` action in ```app/controllers/articles_controller.rb```.

	  def index
	  end
	  
Now we get ```ActionView::MissingTemplate``` because we do not have a view for the action index, so we will create ```app/views/articles/index.html.slim```.

Now, the previous tests should be passing so we create more tests for articles#index:

    it 'populates an array of articles' do
      article = FactoryGirl.create(:article)
      get :index

      assigns(:articles).should eq [article]
    end

By running the test again, we will get:

	ArticlesController GET #index populates an array of articles
     Failure/Error: assigns(:articles).should eq [article]

       expected: [#<Article id: 95, title: "bjije", text: "Aut molestias quia. Commodi voluptatem dignissimos ...", created_at: "2014-07-11 05:51:00", updated_at: "2014-07-11 05:51:00">]
            got: nil
            
So in ```app/controllers/articles_controller.rb```,

	  def index
	    @articles = Article.cached_all
	  end

#####View
Now we will create a simple view to display a list of articles. In ```app/views/articles/index.html.slim```,

	h1 = "List of Articles"
	- Article.cached_all.each do |article|
	  h4 = article.title
	  = article.text

Now you can open your browser to ```http://localhost:9000/articles``` to see the view.

##Exercises
####Extend ```Article```
* cached_find method
* a show view

####Create comments
* ```Comment``` belongs to ```Article```, one article can have many comments
* has a ```subject```, ```content```, and ```email``` field
* ```subject``` is a required field
* ```email``` is a required field, and format should be validated (hint: use regex)
* ```Article``` should have a ```cached_comments``` method
* ```Comment``` should have `cached_all`, `cached_find`, `cached_article` methods
* comments should be displayed on article's show view

##Future Topics

* Regression testing
* Acceptance testing