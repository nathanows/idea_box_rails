require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "example", password: "password")
    visit root_url
  end

  test 'a user sees their idea on their main page' do
    category = Category.create(name: "test_cat")
    user.ideas.create(title: "Great Idea", description: "Such a good idea...", category_id: category.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within("#ideas") do
      assert page.has_content?("Great Idea")
      assert page.has_content?("Such a good idea...")
    end
  end

  test 'a logged in user can create ideas on their page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Category.create(name: "good_ones")
    visit user_path(user)
    fill_in "idea_title", with: "Bad Idea"
    fill_in "idea_description", with: "Such a bad idea..."
    select "good_ones", :from => "idea_category_id"
    click_link_or_button "Create Idea"
    within("#ideas") do
      assert page.has_content?("Bad Idea")
      assert page.has_content?("Such a bad idea...")
      assert page.has_content?("good_ones")
    end
  end

  #test 'a logged in user cannot create ideas for other users' do

  #end

end
