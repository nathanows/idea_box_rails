require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "example", password: "password")
    visit root_url
  end

  test 'a logged in user sees their idea on their main page' do
    category = Category.create(name: "test_cat")
    user.ideas.create(title: "Great Idea", description: "Such a good idea...", category_id: category.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within("#ideas") do
      assert page.has_content?("Great Idea")
      assert page.has_content?("Such a good idea...")
    end
  end

  test 'a user cannot see another users ideas' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    other = User.create(username: "example", password: "password")
    visit user_path(other)
    within('#flash_alert') do
      assert page.has_content?("not authorized")
    end
  end

  test 'a logged in user can create ideas on their page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Category.create(name: "good_ones")
    visit user_path(user)
    fill_in "idea_title", with: "bad idea"
    fill_in "idea_description", with: "such a bad idea..."
    select "good_ones", :from => "idea_category_id"
    click_link_or_button "Create Idea"
    within("#ideas") do
      assert page.has_content?("bad idea")
      assert page.has_content?("such a bad idea...")
      assert page.has_content?("good_ones")
    end
  end

  test 'a logged in user can edit ideas on their page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    cat1 = Category.create(name: "category")
    cat2 = Category.create(name: "original")
    @user.ideas.create(title: "Idea", description: "Description", category_id: cat2.id )
    visit user_path(user)
    click_link_or_button "edit"
    fill_in "idea_title", with: "new idea"
    fill_in "idea_description", with: "new description"
    select "category", :from => "idea_category_id"
    click_link_or_button "Update Idea"
    within("#ideas") do
      assert page.has_content?("new idea")
      assert page.has_content?("new description")
      assert page.has_content?("category")
    end
  end

  test 'a logged in user can delete ideas on their page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    cat2 = Category.create(name: "animals")
    @user.ideas.create(title: "Puppies", description: "Kittens", category_id: cat2.id )
    visit user_path(user)
    within("#ideas") do
      assert page.has_content?("Puppies")
      assert page.has_content?("Kittens")
      assert page.has_content?("animals")
    end
    click_link_or_button "delete"
    within("#ideas") do
      refute page.has_content?("Puppies")
      refute page.has_content?("Kittens")
      refute page.has_content?("animals")
    end
  end

  #test 'a logged in user cannot create ideas for other users' do

  #end

end
