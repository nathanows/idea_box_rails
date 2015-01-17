require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @admin = User.create(username: "admin", password: "admin", role: 'admin')
    @user = User.create(username: "user", password: "user")
    visit root_url
  end

  test 'an admin can go to the Admin page' do
    User.create(username: "admin", password: "password", role: 'admin')
    fill_in "session[username]", with: "admin"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    click_link_or_button "Admin Page"
    within("#admin_title") do
      assert page.has_content?("Admin Page")
    end
  end

  test 'a default user cannot access the Admin page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_path
    within("#flash_alert") do
      assert page.has_content?("not authorized")
    end
  end

  #test 'an admin can create categories' do
    
  #end
end
