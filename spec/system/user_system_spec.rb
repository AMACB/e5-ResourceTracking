require 'spec_helper'

describe "User Management", type: :system do

  it "enables a sign up" do
    visit "/signup"

    fill_in "Email", with: "testsignup@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"

    click_button "Create an account"

    expect(page).to have_selector("#userDropdown", text: "testsignup@example.com")

    User.destroy(User.find_by_email("testsignup@example.com").id)
  end

  it "enables a log in" do
    User.create(email: "testlogin@example.com", password: "password123")
    visit '/login'

    fill_in "Email", with: "testlogin@example.com"
    fill_in "Password", with: "password123"

    click_button "Login"

    expect(page).to have_selector("#userDropdown", text: "testlogin@example.com")
  end

  it "allows email to be confirmed" do
    visit "/signup"

    fill_in "Email", with: "testconfirm@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"

    click_button "Create an account"

    u = User.find_by_email("testconfirm@example.com")
    visit "/confirm_email?token=#{u.confirm_token}"


    expect(page).to have_text("Email was confirmed successfully!")

    User.destroy(User.find_by_email("testconfirm@example.com").id)
  end
end