module LoginHelpers
  def login_with(email_address, password)
    visit new_session_path
    fill_in 'email_address', with: email_address
    fill_in 'password', with: password

    click_button 'Sign in'
  end
end
