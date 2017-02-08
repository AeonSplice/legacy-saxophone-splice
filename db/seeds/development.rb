###########
## Users ##
###########
puts 'Seeding Test Users'

# Until OAuth is implemented, fake passwords for everyone! :D
athix = User.new  username: 'Athix',
                  email: 'admin@aeonsplice.com',
                  password: 'password',
                  password_confirmation: 'password',
                  activation_state: 'active'
athix.bypass_activation_email = true
athix.save!
