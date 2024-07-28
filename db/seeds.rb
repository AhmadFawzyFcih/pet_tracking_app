require 'faker'
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

# Clear existing data
User.destroy_all
Pet.destroy_all

# Create Users
puts "Creating users..."
create(:user, email: "testuser@tractive.com", password: "test123")

10.times do
  create(:user)
end

# Create Pets
puts "Creating pets..."
User.all.each do |user|
  # Create dogs with specific traits
  create_list(:pet, 2, :dog, owner: user)
  create_list(:pet, 1, :dog, owner: user)

  # Create cats with specific traits
  create_list(:pet, 1, :cat, owner: user)
  create_list(:pet, 1, :cat, owner: user)
end

puts "Seeding complete!"
