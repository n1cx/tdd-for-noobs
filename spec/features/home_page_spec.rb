require 'spec_helper'

feature "Home Page", :type => :feature do
  scenario "Home Page must load" do
    visit "/"

    expect(page).to have_text("Welcome")
  end
end