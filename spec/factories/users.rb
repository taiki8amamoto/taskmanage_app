FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'name1' }
    email { 'name1@example.com' }
    password { 'password' }
    role { 0 }
  end
  factory :second_user, class: User do
    name { 'name2' }
    email { 'name2@example.com' }
    password { 'password' }
    role { 5 }
  end
  factory :third_user, class: User do
    name { 'name3' }
    email { 'name3@example.com' }
    password { 'password' }
    role { 5 }
  end
end