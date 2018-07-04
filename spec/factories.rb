FactoryBot.define do
  factory :user do
    email "user@example.com"
    password "password"
    permission_level 0
  end

  factory :admin, class: User do
    email "admin@example.com"
    password "password"
    permission_level 1
  end
end