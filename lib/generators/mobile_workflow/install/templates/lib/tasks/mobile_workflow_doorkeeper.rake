desc "Log the first Doorkeeper App details"
task print_oauth_app: :environment do
  puts Doorkeeper::Application.first.uid
  puts Doorkeeper::Application.first.secret
end