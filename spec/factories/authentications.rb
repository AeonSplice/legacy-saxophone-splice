FactoryGirl.define do
  factory :authentication do
    provider { random_provider }
    sequence(:uid) { |n| "fake-uid-#{n}" }
    user
  end
end

def random_provider
  ['facebook', 'google', 'microsoft', 'twitter'].sample
end
