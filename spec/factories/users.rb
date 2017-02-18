FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User-#{n}" }
    sequence(:email) { |n| "fake-#{n}@example.com" }
    password 'TopSecret'
    password_confirmation 'TopSecret'

    trait :with_one_auth do
      after(:build) do |user|
        user.association(:authentications).add_to_target(build :authentication, user: user)
      end

      before(:create) do |user|
        user.bypass_password = true
        user.setup_activation
      end

      after(:create) do |user|
        user.authentications.each { |auth| auth.save! }
      end
    end

    trait :with_two_auths do
      after(:build) do |user|
        2.times { user.association(:authentications).add_to_target(build :authentication, user: user) }
      end

      before(:create) do |user|
        user.bypass_password = true
        user.setup_activation
      end

      after(:create) do |user|
        user.authentications.each { |auth| auth.save! }
      end
    end

    trait :admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end

    trait :pending do
      activation_state 'pending'
    end

    trait :active do
      activation_state 'active'
    end

    trait :without_password do
      password nil
      password_confirmation nil
    end
  end
end
