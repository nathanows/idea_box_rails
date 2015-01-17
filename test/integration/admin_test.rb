require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

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

  test 'an admin can create categories' do
    admin_user = User.create(username: "admin_user", password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit admin_path
    fill_in "category_name", with: "snoop"
    click_link_or_button "Add Category"
    within("#category_list") do
      assert page.has_content?("snoop")
    end
  end

  test 'an admin can delete categories' do
    admin_user = User.create(username: "admin_user", password: "password", password_confirmation: "password", role: "admin")
    Category.create(name: "ghostface")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit admin_path
    assert 1, Category.all.count
    within("#ghostface_category") do
      click_link_or_button "delete"
    end
    assert 0, Category.all.count
  end

  test 'an admin can edit categories' do
    admin_user = User.create(username: "admin_user", password: "password", password_confirmation: "password", role: "admin")
    Category.create(name: "original")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit admin_path
    within("#category_list") do
      assert page.has_content?("original")
    end
    within("#original_category") do
      click_link_or_button "edit"
    end
    fill_in "category_name", with: "new"
    click_link_or_button "Update"
    within("#category_list") do
      assert page.has_content?("new")
    end
  end
end
