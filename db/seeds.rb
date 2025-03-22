# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample accounts
accounts = [
  { name: 'Engineering Team', description: 'For engineers working on product development' },
  { name: 'Marketing Team', description: 'For marketing and sales personnel' },
  { name: 'Executive Team', description: 'For company executives and leadership' },
  { name: 'Design Team', description: 'For designers and UX researchers' },
  { name: 'Customer Support', description: 'For customer support and success team members' }
]

accounts.each do |account_attrs|
  Account.find_or_create_by!(name: account_attrs[:name]) do |account|
    account.description = account_attrs[:description]
  end
end

puts "#{Account.count} accounts created or updated"
