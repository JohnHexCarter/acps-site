module DashSetup
  def dashboard_setup
    DashObject.create(name: 'Pages', namespace: 'pages')
    DashObject.create(name: 'Profile', namespace: 'profile')
    DashObject.create(name: 'Mailer', namespace: 'mailer')
  end
end
