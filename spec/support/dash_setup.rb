module DashSetup
  def dashboard_setup
    DashObject.create(name: 'Profile', namespace: 'profile')
  end
end
