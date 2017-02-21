FactoryGirl.define do
  factory :article do
    title 'Bacon is sizzling!'
    body 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras ut placerat odio. Integer interdum congue nulla, et venenatis nisi luctus et. Cras at orci vitae est hendrerit vestibulum eu sit amet ipsum. Curabitur tempus dolor est, ac tincidunt turpis commodo et. Sed faucibus lorem ac arcu sagittis, vel semper massa semper. Praesent elementum luctus velit, vitae imperdiet massa tristique ac. Morbi a justo ante. Nunc ac tempor erat, a gravida enim. Donec quis orci neque. Fusce tempus sem at ante sodales semper. Pellentesque et aliquam odio. Sed ut rhoncus nunc. Nam et efficitur erat. Sed facilisis nulla quis ex tincidunt, eu eleifend orci tristique.'
    draft false
    publish_date Time.current
    user

    trait :draft do
      draft true
    end

    trait :unpublished do
      publish_date 1.hour.from_now
    end
  end
end
