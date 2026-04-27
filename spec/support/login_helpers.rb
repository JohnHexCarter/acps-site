module LoginHelpers
  def login_with(email_address, password)
    visit new_session_path
    fill_in 'email_address', with: email_address
    fill_in 'password', with: password

    click_button 'Log in'
  end

  def login
    password = 'P@ssw0rd!!'
    user = create(:user, email_address: 'spec-login@helper.com', password: password)

    login_with(user.email_address, password)
  end
end
