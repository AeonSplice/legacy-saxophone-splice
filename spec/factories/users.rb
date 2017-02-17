FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User-#{n}" }
    sequence(:email) { |n| "fake-#{n}@example.com" }
    password 'TopSecret'
    password_confirmation 'TopSecret'

    factory :admin_user do
      after(:create) do |user|
        user.add_role :admin
      end
    end
  end
end
