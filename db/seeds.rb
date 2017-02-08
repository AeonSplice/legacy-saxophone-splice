ActiveRecord::Base.transaction do
  seed_file = Rails.root.join('db', 'seeds', "#{Rails.env.downcase}.rb")
  puts "Loading #{Rails.env.downcase} seed file"
  load(seed_file)
end unless Rails.env.test?
