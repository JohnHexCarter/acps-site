# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
dash_objects = [
  {
    name: 'Pages',
    namespace: 'pages',
    description: 'Managing front facing content',
    icon_str: 'bookmark-fill'
  },
  {
    name: 'Profile',
    namespace: 'profile',
    description: 'Settings for profile management',
    icon_str: 'gear-fill'
  }
]

dash_objects.each do |dash_obj|
  DashObject.create(
    name: dash_obj[:name],
    namespace: dash_obj[:namespace],
    description: dash_obj[:description]
  )
end
