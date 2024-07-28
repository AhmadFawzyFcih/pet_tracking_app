FactoryBot.define do
  factory :pet do
    type { ["Dog", "Cat"].sample }
    tracker_type { ["small", "medium", "big"].sample }
    in_zone { [true, false].sample }
    association :owner

    trait :cat do
      type { "Cat" }
      lost_tracker { [true, false].sample }
      tracker_type { ["small", "big"].sample }
    end

    trait :dog do
      type { "Dog" }
      tracker_type { ["small", "medium", "big"].sample }
    end
  end
end