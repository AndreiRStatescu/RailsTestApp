# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample accounts
accounts = [
  { 
    name: 'Engineering Team', 
    description: 'For engineers working on product development',
    urls: [
      'https://github.com/organization/repo',
      'https://jira.company.com/projects/eng',
      'https://confluence.company.com/engineering'
    ]
  },
  { 
    name: 'Marketing Team', 
    description: 'For marketing and sales personnel',
    urls: [
      'https://trello.com/marketing',
      'https://drive.google.com/marketing',
      'https://analytics.google.com'
    ]
  },
  { 
    name: 'Executive Team', 
    description: 'For company executives and leadership',
    urls: [
      'https://dashboard.company.com',
      'https://investors.company.com',
      'https://zoom.us/executive'
    ]
  },
  { 
    name: 'Design Team', 
    description: 'For designers and UX researchers',
    urls: [
      'https://figma.com/team/design',
      'https://miro.com/app/board/design',
      'https://dribbble.com/company'
    ]
  },
  { 
    name: 'Customer Support', 
    description: 'For customer support and success team members',
    urls: [
      'https://zendesk.com/support',
      'https://intercom.io/inbox',
      'https://help.company.com/admin'
    ]
  }
]

accounts.each do |account_attrs|
  Account.find_or_create_by!(name: account_attrs[:name]) do |account|
    account.description = account_attrs[:description]
    account.urls = account_attrs[:urls]
  end
end

puts "#{Account.count} accounts created or updated"
