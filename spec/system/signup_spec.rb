require 'rails_helper'

RSpec.describe 'Sign up flow', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'should sign up an user with email, password and password confirmation' do
    visit '/signup'
    expect(page).to have_content('Sign Up Page')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
    expect(page).to have_content('Password confirmation')
    expect(page).to have_content('Back to Login')
  end

  it 'should show the profile page, when I sign up successfully' do
    visit '/signup'

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Create User'
    expect(page).to have_current_path('/profile')
  end

  it 'should show error message in sign up page, when I sign up incorrectly' do
    visit '/signup'

    fill_in 'Email', with: 'test'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Create User'
    expect(page).to have_content('2 errors prohibited this user from being saved')
  end
end
