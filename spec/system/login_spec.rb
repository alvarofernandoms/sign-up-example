require 'rails_helper'

RSpec.describe 'Login flow', type: :system do
  fixtures :users
  before do
    driven_by(:rack_test)
  end

  it 'should login with email and password' do
    visit '/login'
    expect(page).to have_content('Log In')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
  end

  it 'should show the profile page, when I sign up successfully' do
    visit '/login'

    fill_in 'Email', with: 'test1@test.com'
    fill_in 'Password', with: '123123123'
    click_button 'Log In'
    expect(page).to have_current_path('/profile')
  end
end
