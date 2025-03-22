namespace :images do
  desc "Initialize visit counts for all images"
  task initialize_visit_counts: :environment do
    puts "Initializing visit counts for all images..."
    
    count = 0
    Account.find_each do |account|
      if account.image_keys.present?
        ImageStorageService.initialize_missing_visit_counts(account)
        count += account.image_keys.size
      end
    end
    
    puts "Visit counts initialized for #{count} images."
  end
end